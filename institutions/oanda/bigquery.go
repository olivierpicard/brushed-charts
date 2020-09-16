package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/lib/cloudlogging"
	"google.golang.org/api/googleapi"
)

type transactionLog struct {
	Instrument  string `json:"instrument"`
	Date        string `json:"date"`
	Granularity string `json:"granularity"`
}

func (x *transactionLog) equal(bqr bigQueryCandleRow) bool {
	if bqr.Instrument != x.Instrument {
		return false
	}
	if bqr.Date != x.Date {
		return false
	}
	if bqr.Granularity != x.Granularity {
		return false
	}
	return true
}

func streamToBigQuery(candleStream chan latestCandlesArray) {
	const waitingSeconds = 10
	ctx := context.Background()
	streamCtx, streamCancel := context.WithCancel(ctx)
	transactionsLog := loadLatestCandlesFromFile()

	client, err := bigquery.NewClient(ctx, projectID)
	if err != nil {
		err = fmt.Errorf("bigquery.NewClient: %v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}
	defer client.Close()

	insertArchive := client.Dataset(bigQueryDataset).Table(bqPriceArchive).Inserter()
	insertShort := client.Dataset(bigQueryDataset).Table(bqPriceShortterm).Inserter()

	tick := time.NewTicker(time.Second * waitingSeconds)
	var listPrices []bigQueryCandleRow

	for {
		select {
		case csArray := <-candleStream:
			bqRows := csArray.parseForBigQuery()
			bqRows = keepUniqueRows(bqRows, transactionsLog)
			listPrices = append(listPrices, bqRows...)
			updateLogs(listPrices, &transactionsLog)
			saveLogToFile(transactionsLog)
		case <-tick.C:
			fmt.Printf("%+v\n\n", listPrices)
			err = insertCandles(streamCtx, listPrices, insertArchive, insertShort)
			listPrices = []bigQueryCandleRow{}
			if err != nil {
				if e, ok := err.(*googleapi.Error); ok {
					if e.Code == 404 {
						log.Fatalf("Application crash because resources is NotFound : %v", err)
					}
				}
				if strings.Contains(err.Error(), "row insertion failed") {
					streamCancel()
					streamCtx, streamCancel = context.WithCancel(ctx)
				}
			}
		}
	}
}

func insertCandles(ctx context.Context, rows []bigQueryCandleRow, insertArchive, insertShort *bigquery.Inserter) error {
	if err := insertArchive.Put(ctx, rows); err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return err
	}
	if err := insertShort.Put(ctx, rows); err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return err
	}
	return nil
}

func keepUniqueRows(rows []bigQueryCandleRow, log []transactionLog) []bigQueryCandleRow {
	newRows := make([]bigQueryCandleRow, 0)
	for _, row := range rows {
		if !isBQLogContain(row, log) {
			newRows = append(newRows, row)
		}
	}
	return newRows
}

func isBQLogContain(row bigQueryCandleRow, logs []transactionLog) bool {
	for _, log := range logs {
		if log.equal(row) {
			return true
		}
	}
	return false
}

func updateLogs(rows []bigQueryCandleRow, logs *[]transactionLog) {
	similar := func(row bigQueryCandleRow) (bool, int) {
		for i, log := range *logs {
			if log.Instrument == row.Instrument && log.Granularity == row.Granularity {
				return true, i
			}
		}
		return false, -1
	}

	for _, row := range rows {
		isSimilar, index := similar(row)
		if isSimilar {
			(*logs)[index].Date = row.Date
		} else {
			*logs = append(*logs, transactionLog{
				Instrument:  row.Instrument,
				Granularity: row.Granularity,
				Date:        row.Date,
			})
		}
	}
}

func saveLogToFile(logs []transactionLog) {
	data, err := json.MarshalIndent(logs, "", "  ")
	if err != nil {
		err = fmt.Errorf("Can't marshal latestCandles : %v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}
	err = ioutil.WriteFile(latestCandlePath, data, 0644)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		log.Fatalf("Can't write the bigquery history/log file : %v", err)
	}
}

func loadLatestCandlesFromFile() []transactionLog {
	log := make([]transactionLog, 0)

	info, err := os.Stat(latestCandlePath)
	if os.IsNotExist(err) || info.IsDir() {
		err = fmt.Errorf("Latest candle JSON file (%v) does not exist or it's a dir", latestCandlePath)
		cloudlogging.ReportInfo(cloudlogging.EntryFromError(err))
		return log
	}

	data, err := ioutil.ReadFile(latestCandlePath)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return log
	}

	err = json.Unmarshal(data, &log)
	if err != nil {
		err = fmt.Errorf("Can't load json from %v file", latestCandlePath)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
	}

	return log
}

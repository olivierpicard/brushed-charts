package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/tools/cloudlogging"
)

type transactionLog struct {
	Instrument string `json:"instrument"`
	Date       string `json:"date"`
	Interval   string `json:"interval"`
}

func (x *transactionLog) equal(bqr bigQueryCandleRow) bool {
	if bqr.Instrument != x.Instrument {
		return false
	}
	if bqr.Date != x.Date {
		return false
	}
	if bqr.Interval != x.Interval {
		return false
	}
	return true
}

func streamToBigQuery(candleStream chan latestCandlesArray) {
	const waitingSeconds = 10
	ctx := context.Background()
	transactionsLog := make([]transactionLog, 0)

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
			err := insertCandles(ctx, listPrices, insertArchive, insertShort)
			if err != nil {
				cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
				continue
			}
			listPrices = []bigQueryCandleRow{}
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
			if log.Instrument == row.Instrument && log.Interval == row.Interval {
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
				Instrument: row.Instrument,
				Interval:   row.Interval,
				Date:       row.Date,
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
	}
}

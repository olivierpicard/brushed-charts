package main

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/tools/cloudlogging"
)

type transactionLog struct {
	instrument string
	date       string
	interval   string
}

func (x *transactionLog) equal(bqr bigQueryCandleRow) bool {
	if bqr.Instrument != x.instrument {
		return false
	}
	if bqr.Date != x.date {
		return false
	}
	if bqr.Interval != x.interval {
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

	tick := time.Tick(time.Second * waitingSeconds)
	var listPrices []bigQueryCandleRow

	for {
		select {
		case csArray := <-candleStream:
			bqRows := csArray.parseForBigQuery()
			bqRows = keepUniqueRows(bqRows, transactionsLog)
			listPrices = append(listPrices, bqRows...)
		case <-tick:
			err := insertCandles(ctx, listPrices, insertArchive, insertShort)
			updateLogs(listPrices, &transactionsLog)
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
			if log.instrument == row.Instrument && log.interval == row.Interval {
				return true, i
			}
		}
		return false, -1
	}

	for _, row := range rows {
		isSimilar, index := similar(row)
		if isSimilar {
			(*logs)[index].date = row.Date
		} else {
			*logs = append(*logs, transactionLog{
				instrument: row.Instrument,
				interval:   row.Interval,
				date:       row.Date,
			})
		}
	}
}

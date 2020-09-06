package main

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/tools/cloudlogging"
)

func streamToBigQuery(candleStream chan latestCandlesArray) {
	const waitingSeconds = 10
	ctx := context.Background()

	client, err := bigquery.NewClient(ctx, projectID)
	if err != nil {
		err = fmt.Errorf("bigquery.NewClient: %v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}
	defer client.Close()

	insertArchive := client.Dataset(bigQueryDataset).Table(bqTableNameArchive).Inserter()
	insertShort := client.Dataset(bigQueryDataset).Table(bqTableNameShortterm).Inserter()

	tick := time.Tick(time.Second * waitingSeconds)
	var listPrices []bigQueryCandleRow

	for {
		select {
		case csArray := <-candleStream:
			bqRows := csArray.parseForBigQuery()
			listPrices = append(listPrices, bqRows...)
		case <-tick:
			err := insertCandles(ctx, listPrices, insertArchive, insertShort)
			listPrices = []bigQueryCandleRow{}
			if err != nil {
				cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
				return
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

package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/lib/cloudlogging"
	"google.golang.org/api/googleapi"
)

func streamToBigQuery(candleStream chan latestCandlesArray) {
	const waitingSeconds = 10
	var history bigqueryCandleHistory
	var waitingCandle []bigQueryCandleRow

	history.load(latestCandlePath)
	ctx := context.Background()

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

	for {
		select {
		case incomingCandles := <-candleStream:
			onIncomingCandle(incomingCandles, &waitingCandle, &history)
		case <-tick.C:
			onInsertionTick(ctx, &waitingCandle, insertArchive, insertShort)
		}

	}
}

func onIncomingCandle(inCand latestCandlesArray, waitCand *[]bigQueryCandleRow,
	hist *bigqueryCandleHistory) {

	bqRows := prepareIncomingCandles(*hist, inCand)
	*waitCand = append(*waitCand, bqRows...)
	hist.update(*waitCand)
	hist.save(latestCandlePath)
}

func onInsertionTick(ctx context.Context, waitingCandle *[]bigQueryCandleRow,
	insertArchive, insertShort *bigquery.Inserter) {
	err := insertCandles(ctx, *waitingCandle, insertArchive, insertShort)
	*waitingCandle = []bigQueryCandleRow{}
	manageInsertionFatalError(err)
}

func prepareIncomingCandles(history bigqueryCandleHistory, candSlice latestCandlesArray) []bigQueryCandleRow {
	bqRows := candSlice.parseForBigQuery()
	bqRows = bigqueryKeepUniqueCandleRow(history, bqRows)
	return bqRows
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

func manageInsertionFatalError(err error) {
	if err == nil {
		return
	}

	if e, ok := err.(*googleapi.Error); ok {
		if e.Code == 404 {
			log.Fatalf("Application crash because resources is NotFound : %v", err)
		}
	}
}

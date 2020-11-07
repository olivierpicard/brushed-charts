package main

import (
	"github.com/brushed-charts/backend/institutions/oanda/src/bigquery"
	"github.com/brushed-charts/backend/institutions/oanda/src/candlefetcher"
	"github.com/brushed-charts/backend/lib/cloudlog"
)

func saveCandleStreamToBigquery(candleStream chan candlefetcher.Response) {
	history := initHistory()
	candleLink := makeCandleLink()
	bigquery.WaitForInsertion(candleLink)

	for candles := range candleStream {
		bigqueryRows := convertCandlesToBigquery(candles)
		freshBigqueryRows := keepOnlyFreshRow(history, bigqueryRows)
		insertToCandleLink(candleLink, freshBigqueryRows)
	}
}

func initHistory() bigquery.CandleHistory {
	var history bigquery.CandleHistory
	err := history.Load(latestCandlePath)
	if err != nil {
		cloudlog.Panic(err)
	}
	return history
}

func makeCandleLink() bigquery.CandleLink {
	candlelink := bigquery.CandleLink{
		Dataset:             bigQueryDataset,
		GCPProjectID:        projectID,
		TablePriceArchive:   bqPriceArchive,
		TablePriceShortterm: bqPriceShortterm,
	}
	candlelink.Init()

	return candlelink
}

func keepOnlyFreshRow(history bigquery.CandleHistory, rows []bigquery.CandleRow) []bigquery.CandleRow {
	var freshRows []bigquery.CandleRow

	for _, row := range rows {
		isFresh, err := history.IsAFreshRow(row)
		if err != nil {
			cloudlog.Panic(err)
		}
		if isFresh {
			freshRows = append(freshRows, row)
		}
	}

	return freshRows
}

func insertToCandleLink(candleLink bigquery.CandleLink, rows []bigquery.CandleRow) {
	for _, row := range rows {
		candleLink.InputCandleStream <- row
	}
}

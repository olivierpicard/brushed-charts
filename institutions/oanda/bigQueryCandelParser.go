package main

import (
	"fmt"
	"strconv"

	"github.com/brushed-charts/backend/tools/cloudlogging"
)

type bigQueryCandleData struct {
	Open  float64
	High  float64
	Low   float64
	Close float64
}

type bigQueryCandleRow struct {
	Instrument string
	Date       string
	Interval   string
	Bid        bigQueryCandleData
	Ask        bigQueryCandleData
	Volume     int
}

func (candArr *latestCandlesArray) parseForBigQuery() []bigQueryCandleRow {
	rows := make([]bigQueryCandleRow, 0)
	for _, meta := range candArr.LatestCandles {
		bqRow := bigQueryCandleRow{}
		bqRow.Interval = meta.Granularity
		bqRow.Instrument = meta.Instrument

		for _, cand := range meta.Candles {
			if !cand.Complete {
				continue
			}

			bqRow.Date = cand.Time
			bqRow.Bid, _ = cand.Bid.parseForBigQuery()
			bqRow.Ask, _ = cand.Ask.parseForBigQuery()
			bqRow.Volume = cand.Volume

			if bqRow.Bid == (bigQueryCandleData{}) || bqRow.Ask == (bigQueryCandleData{}) {
				err := fmt.Errorf("Error during CandlesData parsing to float")
				cloudlogging.ReportCritical((cloudlogging.EntryFromError(err)))
			}
		}

		if bqRow.Date == "" {
			continue
		}

		rows = append(rows, bqRow)
	}
	return rows
}

func (data *candlestickData) parseForBigQuery() (bigQueryCandleData, error) {
	open, err := strconv.ParseFloat(data.Open, 64)
	if err != nil {
		return bigQueryCandleData{}, err
	}

	high, err := strconv.ParseFloat(data.High, 64)
	if err != nil {
		return bigQueryCandleData{}, err
	}

	low, err := strconv.ParseFloat(data.Low, 64)
	if err != nil {
		return bigQueryCandleData{}, err
	}

	close, err := strconv.ParseFloat(data.Close, 64)
	if err != nil {
		return bigQueryCandleData{}, err
	}

	return bigQueryCandleData{
		Open:  open,
		High:  high,
		Low:   low,
		Close: close,
	}, nil
}

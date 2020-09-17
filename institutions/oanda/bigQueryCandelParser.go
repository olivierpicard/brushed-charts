package main

import (
	"fmt"
	"strconv"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/lib/cloudlogging"
)

type bigQueryCandleData struct {
	Open  float64 `json:"open"`
	High  float64 `json:"high"`
	Low   float64 `json:"low"`
	Close float64 `json:"close"`
}

func (c *bigQueryCandleData) Save() (map[string]bigquery.Value, string, error) {
	return map[string]bigquery.Value{
		"open":  c.Open,
		"high":  c.High,
		"low":   c.Low,
		"close": c.Close,
	}, "", nil
}

type bigQueryCandleRow struct {
	Instrument  string             `json:"instrument"`
	Date        string             `json:"date"`
	Granularity string             `json:"granularity"`
	Bid         bigQueryCandleData `json:"bid"`
	Ask         bigQueryCandleData `json:"ask"`
	Volume      int                `json:"volume"`
}

func (c *bigQueryCandleRow) Save() (map[string]bigquery.Value, string, error) {
	return map[string]bigquery.Value{
		"instrument":  c.Instrument,
		"date":        c.Date,
		"granularity": c.Granularity,
		"bid":         c.Bid,
		"ask":         c.Ask,
		"volume":      c.Volume,
	}, "", nil
}

func (candArr *latestCandlesArray) parseForBigQuery() []bigQueryCandleRow {
	rows := make([]bigQueryCandleRow, 0)
	for _, meta := range candArr.LatestCandles {
		bqRow := bigQueryCandleRow{}
		bqRow.Granularity = meta.Granularity
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

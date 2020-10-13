package main

import (
	"strconv"

	"github.com/brushed-charts/backend/institutions/oanda/src/bigquery"
	"github.com/brushed-charts/backend/institutions/oanda/src/candle"
)

func convertCandlesToBigquery(response candle.Response) []bigquery.CandleRow {
	rows := make([]bigquery.CandleRow, 0)

	for _, latestCandles := range response.LatestCandles {
		extractedRows := getBigQueryRowsFromCandle(latestCandles)
		rows = append(rows, extractedRows...)
	}

	return rows
}

func getBigQueryRowsFromCandle(candlePacket candle.PacketOfCandles) []bigquery.CandleRow {
	rows := make([]bigquery.CandleRow, 0)

	for _, marketAtTime := range candlePacket.MarketAtTime {
		row, err := makeBigqueryRow(marketAtTime, candlePacket)
		if !marketAtTime.Complete || err != nil {
			continue
		}
		rows = append(rows, row)
	}

	return rows
}

func makeBigqueryRow(marketAtTime candle.MarketAtTime, candlePacket candle.PacketOfCandles) (bigquery.CandleRow, error) {
	var row bigquery.CandleRow
	updateBigqueryFromCandleMetadata(&row, candlePacket)
	err := updateRowWithMarketAtTime(&row, marketAtTime)
	return row, err
}

func updateBigqueryFromCandleMetadata(row *bigquery.CandleRow, candlePacket candle.PacketOfCandles) {
	row.Instrument = candlePacket.Instrument
	row.Granularity = candlePacket.Granularity
}

func updateRowWithMarketAtTime(bigqueryRow *bigquery.CandleRow, candle candle.MarketAtTime) error {
	var err error
	bigqueryRow.Date = candle.Time
	bigqueryRow.Volume = candle.Volume

	bigqueryRow.Ask, err = parseOHLCForBigQuery(candle.Ask)
	if err != nil {
		return err
	}

	bigqueryRow.Bid, err = parseOHLCForBigQuery(candle.Bid)
	if err != nil {
		return err
	}

	return nil
}

func parseOHLCForBigQuery(ohlc candle.OHLC) (bigquery.CandleOHLC, error) {
	open, err := strconv.ParseFloat(ohlc.Open, 64)
	if err != nil {
		return bigquery.CandleOHLC{}, err
	}

	high, err := strconv.ParseFloat(ohlc.High, 64)
	if err != nil {
		return bigquery.CandleOHLC{}, err
	}

	low, err := strconv.ParseFloat(ohlc.Low, 64)
	if err != nil {
		return bigquery.CandleOHLC{}, err
	}

	close, err := strconv.ParseFloat(ohlc.Close, 64)
	if err != nil {
		return bigquery.CandleOHLC{}, err
	}

	return bigquery.CandleOHLC{
		Open:  open,
		High:  high,
		Low:   low,
		Close: close,
	}, nil
}

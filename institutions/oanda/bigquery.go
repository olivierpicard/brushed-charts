package main

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/brushed-charts/backend/tools/cloudlogging"
)

type bigQueryRow struct {
	Instrument string
	Date       string
	Bid        float64
	Ask        float64
	Volume     int
}

// Save implements the ValueSaver interface.
func (i *bigQueryRow) Save() (map[string]bigquery.Value, string, error) {
	return map[string]bigquery.Value{
		"instrument": i.Instrument,
		"date":       i.Date,
		"bid":        i.Bid,
		"ask":        i.Ask,
		"volume":     i.Volume,
	}, "", nil
}

func (ps *pricingStream) toBigQueryRow() (bigQueryRow, error) {
	volume := len(ps.Asks) + len(ps.Bids)

	bid, err := strconv.ParseFloat(ps.Bid, 64)
	if err != nil {
		return bigQueryRow{}, err
	}

	ask, err := strconv.ParseFloat(ps.Ask, 64)
	if err != nil {
		return bigQueryRow{}, err
	}

	return bigQueryRow{
		Instrument: ps.Instrument,
		Date:       ps.Time,
		Bid:        bid,
		Ask:        ask,
		Volume:     volume,
	}, nil
}

func insertStreamingBigQueryRow(streamPrice chan pricingStream, errorStreamPrice chan error) {
	const waitingSeconds = 10
	const streamArchiveID = "pricing_stream_archive"
	const streamshorttermID = "pricing_stream_shortterm"
	ctx := context.Background()

	client, err := bigquery.NewClient(ctx, projectID)
	if err != nil {
		err = fmt.Errorf("bigquery.NewClient: %v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}
	defer client.Close()
	insertArchive := client.Dataset(bigQueryDataset).Table(streamArchiveID).Inserter()
	insertShort := client.Dataset(bigQueryDataset).Table(streamshorttermID).Inserter()
	tick := time.Tick(time.Second * waitingSeconds)
	var listPrices []pricingStream

	for {
		select {
		case sp := <-streamPrice:
			listPrices = append(listPrices, sp)
		case err := <-errorStreamPrice:
			err = fmt.Errorf("BigQuery Stream insertion is stopped due to error : %v", err)
			cloudlogging.ReportEmergency(cloudlogging.EntryFromError(err))
			errorStreamPrice <- err
			return
		case <-tick:
			err := onPrice(ctx, listPrices, insertArchive, insertShort)
			listPrices = []pricingStream{}
			if err != nil {
				errorStreamPrice <- err
				return
			}
		}
	}
}

func onPrice(ctx context.Context, prices []pricingStream, insertArchive, insertShort *bigquery.Inserter) error {
	rows, err := buildBigQueryPrice(prices)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return err
	}

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

func buildBigQueryPrice(prices []pricingStream) ([]bigQueryRow, error) {
	var bqrows []bigQueryRow
	for _, sp := range prices {
		bqrow, err := sp.toBigQueryRow()

		if err != nil {
			err := fmt.Errorf("Trying to convert "+sp.Bid+" or "+sp.Ask+" to float64 : %v", err)
			cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
			return []bigQueryRow{}, err
		}
		bqrows = append(bqrows, bqrow)
	}

	return bqrows, nil
}

package bigquery

import (
	"time"

	"github.com/pkg/errors"
)

const (
	sendingTimer = 10 // In seconds
)

// SaveCandleRow save candle to bigquery in table archive and shortterm
func SaveCandleRow(entry CandleRowEntry) {
	var cumulatedRows []CandleRow
	tick := time.NewTicker(time.Second * sendingTimer)
	for {
		select {
		case inputCandle := <-entry.InputCandleStream:
			cumulatedRows = append(cumulatedRows, inputCandle)
		case <-tick.C:
			insertCandleRow(entry, cumulatedRows)
		}
	}
}

func insertCandleRow(entry CandleRowEntry, rows []CandleRow) {
	for _, inserter := range entry.inserters {
		if err := inserter.Put(entry.context, rows); err != nil {
			entry.OutputError <- errors.New(err.Error())
		}
	}
}

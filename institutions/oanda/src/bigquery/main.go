package bigquery

import (
	"time"

	"github.com/pkg/errors"
)

const (
	sendingTimer = 10 // In seconds
)

// WaitForInsertion save candle to bigquery in table archive and shortterm
func WaitForInsertion(link CandleLink) {
	var cumulatedRows []CandleRow
	tick := time.NewTicker(time.Second * sendingTimer)
	for {
		select {
		case inputCandle := <-link.InputCandleStream:
			cumulatedRows = append(cumulatedRows, inputCandle)
		case <-tick.C:
			insertCandleRow(link, cumulatedRows)
		}
	}
}

func insertCandleRow(link CandleLink, rows []CandleRow) {
	for _, inserter := range link.inserters {
		if err := inserter.Put(link.context, rows); err != nil {
			link.OutputError <- errors.New(err.Error())
		}
	}
}

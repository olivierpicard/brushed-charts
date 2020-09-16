package main

import (
	"github.com/google/go-cmp/cmp"
	"github.com/google/go-cmp/cmp/cmpopts"
)

type bigqueryCandleHistory []bigQueryCandleRow

func (history *bigqueryCandleHistory) contains(row bigQueryCandleRow) bool {
	for _, h := range *history {
		if cmp.Equal(row, h) {
			return true
		}
	}
	return false
}

func (history *bigqueryCandleHistory) getIndexOfSimilar(row bigQueryCandleRow) int {
	options := cmpopts.IgnoreFields(bigQueryCandleRow{}, "Date")

	for i, h := range *history {
		if cmp.Equal(h, row, options) {
			return i
		}
	}

	return -1
}

func (history *bigqueryCandleHistory) update(rows []bigQueryCandleRow) {
	for _, row := range rows {
		index := history.getIndexOfSimilar(row)
		if index == -1 {
			*history = append(*history, row)
			continue
		}
		(*history)[index] = row
	}
}

func bigqueryKeepUniqueCandleRow(history bigqueryCandleHistory, rows []bigQueryCandleRow) []bigQueryCandleRow {
	uniqRow := []bigQueryCandleRow{}
	for _, row := range rows {
		if !history.contains(row) {
			uniqRow = append(uniqRow, row)
		}
	}
	return uniqRow
}

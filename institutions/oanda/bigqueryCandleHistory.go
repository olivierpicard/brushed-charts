package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"

	"github.com/brushed-charts/backend/lib/cloudlogging"
)

type bigqueryCandleHistory []bigQueryCandleRow

func (history *bigqueryCandleHistory) contains(row bigQueryCandleRow) bool {
	for _, h := range *history {
		if row.Equal(h) {
			return true
		}
	}
	return false
}

func (history *bigqueryCandleHistory) update(rows []bigQueryCandleRow) {
	for _, row := range rows {
		if history.contains(row) {
			continue
		}
		*history = append(*history, row)
	}
}

func (history *bigqueryCandleHistory) load(filename string) {
	info, err := os.Stat(latestCandlePath)
	if os.IsNotExist(err) || info.IsDir() {
		return
	}

	data, err := ioutil.ReadFile(latestCandlePath)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}

	err = json.Unmarshal(data, history)
	if err != nil {
		err = fmt.Errorf("Can't load json from %v file -- error : %v", latestCandlePath, err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
	}
}

func (history *bigqueryCandleHistory) save(filepath string) {
	data, err := json.MarshalIndent(*history, "", "  ")
	if err != nil {
		err = fmt.Errorf("Can't marshal bigqueryCandleHistory : %v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}

	err = ioutil.WriteFile(filepath, data, 0644)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		log.Fatalf("Can't write the bigquery history file : %v", err)
	}
}

func (history *bigqueryCandleHistory) getSimilarIndexCounter(instrument, granularity string) ([]int, int) {
	var index []int
	counter := 0
	for i, h := range *history {
		if instrument == h.Instrument && granularity == h.Granularity {
			counter++
			index = append(index, i)
		}
	}
	return index, counter
}

func (history *bigqueryCandleHistory) prune(latestCand latestCandlesArray) {
	const minRowToKeep = 6
	bqrows := latestCand.parseForBigQuery()

	for _, row := range bqrows {
		index, count := history.getSimilarIndexCounter(row.Instrument, row.Granularity)
		if count <= minRowToKeep {
			continue
		}

		counterOverflow := count - minRowToKeep
		sort.Ints(index)
		index = index[:counterOverflow]
		deletionCounter := 0

		for i := range index {
			indexToDel := i - deletionCounter
			*history = append((*history)[:indexToDel], (*history)[indexToDel+1:]...)
			deletionCounter++
		}
		_, c := history.getSimilarIndexCounter(row.Instrument, row.Granularity)
		fmt.Printf("%v -- %v -- %v\n", c, row.Instrument, row.Granularity)
		// for hindex, h := range *history {
		// 	isIn := false
		// 	for _, i := range indexToDel {
		// 		if hindex == i {
		// 			isIn = true
		// 		}
		// 	}
		// 	if !isIn {
		// 		newHist = append(newHist, h)
		// 	}
		// }
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

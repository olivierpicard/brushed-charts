package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

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

func (history *bigqueryCandleHistory) getIndexOfSimilar(row bigQueryCandleRow) int {
	for i, h := range *history {
		if h.EqualIgnoreDate(row) {
			return i
		}
	}
	return -1
}

func (history *bigqueryCandleHistory) update(rows []bigQueryCandleRow) {
	for _, row := range rows {
		index := history.getIndexOfSimilar(row)
		if index != -1 {
			(*history)[index] = row
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

func bigqueryKeepUniqueCandleRow(history bigqueryCandleHistory, rows []bigQueryCandleRow) []bigQueryCandleRow {
	uniqRow := []bigQueryCandleRow{}
	for _, row := range rows {
		index := history.getIndexOfSimilar(row)
		if index == -1 {
			uniqRow = append(uniqRow, row)
			continue
		}
		isGreater, err := DateGreater(row.Date, history[index].Date)
		if err != nil {
			cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
			log.Fatalf("%v", err)
		}

		if isGreater {
			uniqRow = append(uniqRow, row)
		}
	}
	return uniqRow
}

package bigquery

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/pkg/errors"
)

// CandleHistory represent latest candle received and sended to bigquery
type CandleHistory []CandleRow

// IsAFreshRow determine if the given row is newer than history one. It avoid
// insert in bigquery old duplicated row.
func (history *CandleHistory) IsAFreshRow(row CandleRow) (bool, error) {
	const notFound = -1
	index := history.getIndexOfSimilar(row)
	if index == notFound {
		return true, nil
	}
	isGreater, err := util.IsDateGreater(row.Date, (*history)[index].Date)
	if isGreater {
		return true, nil
	}
	return false, err
}

func (history *CandleHistory) getIndexOfSimilar(row CandleRow) int {
	for i, h := range *history {
		if h.equalIgnoreDate(row) {
			return i
		}
	}
	return -1
}

// Update history, by adding a new row if needed or by updated
// edited information already there
func (history *CandleHistory) Update(rows []CandleRow) {
	for _, row := range rows {
		index := history.getIndexOfSimilar(row)
		if index == -1 {
			*history = append(*history, row)
			continue
		}
		(*history)[index] = row
	}
}

// Load history from a json file.
func (history *CandleHistory) Load(filepath string) error {
	info, err := os.Stat(filepath)

	if os.IsNotExist(err) {
		return nil
	}

	if info.IsDir() {
		return errors.New("Can't load a dir")
	}

	data, err := ioutil.ReadFile(filepath)
	if err != nil {
		return errors.New(err.Error())
	}

	err = json.Unmarshal(data, history)
	if err != nil {
		err = errors.New(fmt.Sprintf("Can't load json from %v file -- error : %v", filepath, err))
		return err
	}

	err = history.KeepOnlyLatestRows()
	if err != nil {
		return errors.New(err.Error())
	}

	return nil
}

// Save history to a json file
func (history *CandleHistory) Save(filepath string) error {
	data, err := json.MarshalIndent(*history, "", "  ")
	if err != nil {
		err = errors.New(fmt.Sprintf("Can't marshal bigqueryCandleHistory : %v", err))
		return err
	}

	err = ioutil.WriteFile(filepath, data, 0644)
	if err != nil {
		err = errors.New(fmt.Sprintf("Can't write the bigquery history file : %v", err))
		return err
	}

	return nil
}

// KeepOnlyLatestRows purge old candles base on date with the same
// granularity and instrument. It will keep only the newest rows
func (history *CandleHistory) KeepOnlyLatestRows() error {
	var candleToKeep CandleHistory
	for _, row := range *history {
		isfresh, err := candleToKeep.IsAFreshRow(row)
		if err != nil {
			return errors.New(err.Error())
		}
		if isfresh {
			candleToKeep = append(candleToKeep, row)
		}
	}
	(*history) = candleToKeep
	return nil
}

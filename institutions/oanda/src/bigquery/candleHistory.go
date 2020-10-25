package bigquery

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/pkg/errors"
)

type candleHistory []CandleRow

func (history *candleHistory) IsAFreshRow(row CandleRow) (bool, error) {
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

func (history *candleHistory) getIndexOfSimilar(row CandleRow) int {
	for i, h := range *history {
		if h.equalIgnoreDate(row) {
			return i
		}
	}
	return -1
}

func (history *candleHistory) update(rows []CandleRow) {
	for _, row := range rows {
		index := history.getIndexOfSimilar(row)
		if index == -1 {
			*history = append(*history, row)
			continue
		}
		(*history)[index] = row
	}
}

func (history *candleHistory) load(filepath string) error {
	info, err := os.Stat(filepath)
	if os.IsNotExist(err) || info.IsDir() {
		return nil
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
	return nil
}

func (history *candleHistory) save(filepath string) error {
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

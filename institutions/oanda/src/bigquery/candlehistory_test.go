package bigquery

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"testing"

	"github.com/tj/assert"
)

const (
	mockPath = "/etc/brushed-charts/mock/"
)

func Test_load(t *testing.T) {
	expectedHistory := makeCandleHistory("2020-11-21T12:00:00.0000Z", "S5", "EUR_USD")
	history := candleHistory{}
	err := history.load(mockPath + "bigquery_candleHistory_loadsaveTest.json")
	assert.Nil(t, err)
	assert.Equal(t, expectedHistory, history)
}

func makeCandleHistory(date, granularity, instrument string) candleHistory {
	candle := CandleRow{
		Date:        date,
		Granularity: granularity,
		Instrument:  instrument,
		Bid: CandleOHLC{
			Open:  1.03455,
			High:  1.03495,
			Low:   1.03435,
			Close: 1.03455,
		},
		Ask: CandleOHLC{
			Open:  1.03415,
			High:  1.03445,
			Low:   1.03465,
			Close: 1.03425,
		},
		Volume: 12342,
	}
	history := candleHistory{candle}
	return history
}

func Test_save(t *testing.T) {
	var currentHistory candleHistory
	expectedHistory := makeCandleHistory("2020-11-21T12:00:00.0000Z", "S5", "EUR_USD")
	savedFilePath := os.TempDir() + "bigquery_candleHistory_loadsaveTest.json"
	err := expectedHistory.save(savedFilePath)
	assert.Nil(t, err)

	currentHistory = loadHistoryFile(t, savedFilePath)

	err = os.Remove(savedFilePath)
	assert.Nil(t, err)

	assert.Equal(t, expectedHistory, currentHistory)
}

func loadHistoryFile(t *testing.T, filename string) candleHistory {
	var history candleHistory
	savedFile, err := ioutil.ReadFile(filename)
	assert.Nil(t, err)

	err = json.Unmarshal(savedFile, &history)
	assert.Nil(t, err)

	return history
}

func Test_IsAFreshRow_true(t *testing.T) {
	// Increase candle history by 1 hour in comparaison to "bigquery_candleHistory.json" file
	freshHistory := makeCandleHistory("2020-11-21T13:00:00.0000Z", "S5", "EUR_USD")
	freshRow := freshHistory[0]

	history := loadHistoryFile(t, mockPath+"bigquery_candleHistory.json")

	isFresh, err := history.IsAFreshRow(freshRow)
	assert.Nil(t, err)
	assert.True(t, isFresh)
}

func Test_IsAFreshRow_false(t *testing.T) {
	// Decrease candle history by 1 hour in comparaison to "bigquery_candleHistory.json" file
	freshHistory := makeCandleHistory("2020-11-21T11:55:00.0000Z", "S5", "EUR_USD")
	freshRow := freshHistory[0]

	var history = loadHistoryFile(t, mockPath+"bigquery_candleHistory.json")

	isFresh, err := history.IsAFreshRow(freshRow)
	assert.Nil(t, err)
	assert.False(t, isFresh)
}

func Test_History_Update(t *testing.T) {
	const originalDate = "2020-11-21T12:00:00.0000Z"
	const updatedDate = "2020-11-21T13:55:00.0000Z"
	history := loadHistoryFile(t, mockPath+"bigquery_candleHistory.json")
	assert.Equal(t, originalDate, history[0].Date)

	historyGenerated := makeCandleHistory(updatedDate, "S5", "EUR_USD")
	extractedRow := historyGenerated[0]
	rowsUseToUpdate := []CandleRow{extractedRow}

	history.update(rowsUseToUpdate)
	assert.Equal(t, updatedDate, history[0].Date)
}

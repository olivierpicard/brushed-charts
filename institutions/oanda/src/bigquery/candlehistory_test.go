package bigquery

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"testing"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/tj/assert"
)

const (
	mockPath = "/etc/brushed-charts/mock/"
)

func Test_load(t *testing.T) {
	expectedHistory := makeCandleHistory("2020-11-21T12:00:00.0000Z", "S5", "EUR_USD")
	history := CandleHistory{}
	err := history.Load(mockPath + "bigquery_candleHistory_loadsaveTest.json")
	assert.Nil(t, err)
	assert.Equal(t, expectedHistory, history)
}

func makeCandleHistory(date, granularity, instrument string) CandleHistory {
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
	history := CandleHistory{candle}
	return history
}

func Test_save(t *testing.T) {
	var currentHistory CandleHistory
	expectedHistory := makeCandleHistory("2020-11-21T12:00:00.0000Z", "S5", "EUR_USD")
	savedFilePath := os.TempDir() + "bigquery_candleHistory_loadsaveTest.json"
	err := expectedHistory.Save(savedFilePath)
	assert.Nil(t, err)

	currentHistory = loadHistoryFile(t, savedFilePath)

	err = os.Remove(savedFilePath)
	assert.Nil(t, err)

	assert.Equal(t, expectedHistory, currentHistory)
}

func loadHistoryFile(t *testing.T, filename string) CandleHistory {
	var history CandleHistory
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

	history := loadHistoryFile(t, mockPath+"bigquery_candleHistory_dirty_withFreshAndOldDataMixed.json")

	isFresh, err := history.IsAFreshRow(freshRow)
	assert.Nil(t, err)
	assert.True(t, isFresh)
}

func Test_IsAFreshRow_false(t *testing.T) {
	// Decrease candle history by 1 hour in comparaison to "bigquery_candleHistory.json" file
	freshHistory := makeCandleHistory("2020-11-21T11:55:00.0000Z", "S5", "EUR_USD")
	freshRow := freshHistory[0]

	var history = loadHistoryFile(t, mockPath+"bigquery_candleHistory_dirty_withFreshAndOldDataMixed.json")

	isFresh, err := history.IsAFreshRow(freshRow)
	assert.Nil(t, err)
	assert.False(t, isFresh)
}

func Test_History_Update(t *testing.T) {
	const originalDate = "2020-11-21T12:00:00.0000Z"
	const updatedDate = "2020-11-21T13:55:00.0000Z"
	history := loadHistoryFile(t, mockPath+"bigquery_candleHistory_dirty_withFreshAndOldDataMixed.json")
	assert.Equal(t, originalDate, history[0].Date)

	historyGenerated := makeCandleHistory(updatedDate, "S5", "EUR_USD")
	extractedRow := historyGenerated[0]
	rowsUseToUpdate := []CandleRow{extractedRow}

	history.Update(rowsUseToUpdate)
	assert.Equal(t, updatedDate, history[0].Date)
}

func Test_KeepOnlyLatestRows(t *testing.T) {
	actualHistory := loadHistoryFile(t, mockPath+"bigquery_candleHistory_dirty_withFreshAndOldDataMixed.json")
	actualHistory.KeepOnlyLatestRows()

	expectedHistory := loadHistoryFile(t, mockPath+"expectedBigqueryRow_clean_basedOn_streamCandleFile.json")
	testHistoryCandlesEquality(t, expectedHistory, actualHistory)
}

func testHistoryCandlesEquality(t *testing.T, expected, actual CandleHistory) {
	const pathCandleExpected = "/tmp/expectedCandleHistory.json"
	const pathCandleActual = "/tmp/actualCandleHistory.json"

	err := expected.Save(pathCandleExpected)
	assert.Nil(t, err)

	expected.Save(pathCandleActual)
	assert.Nil(t, err)

	util.TestJSONFileEquality(t, pathCandleExpected, pathCandleActual)
}

package main

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/brushed-charts/backend/institutions/oanda/src/bigquery"
	"github.com/brushed-charts/backend/institutions/oanda/src/candle"
	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/tj/assert"
)

const (
	pathToMock = "/etc/brushed-charts/mock/"
)

func Test_convertCandleToBigquery(t *testing.T) {
	var mockCandleResponse candle.Response
	var expectedBigqueryRow []bigquery.CandleRow
	var actualBigqueryRow []bigquery.CandleRow
	const expectedRowCount = 5

	mockCandleReader := getTestedReaderFromFile(t, pathToMock+"streamCandles.json")
	decodeFromReader(t, mockCandleReader, &mockCandleResponse)

	actualBigqueryRow = convertCandlesToBigquery(mockCandleResponse)
	testBigqueryRow(t, actualBigqueryRow, expectedRowCount)

	bigqueryExpectationReader := getTestedReaderFromFile(t, pathToMock+"expectedBigqueryRow_basedOn_streamCandleFile.json")
	decodeFromReader(t, bigqueryExpectationReader, &expectedBigqueryRow)

	assert.Equal(t, expectedBigqueryRow, actualBigqueryRow)
}

func getTestedReaderFromFile(t *testing.T, filepath string) *strings.Reader {
	streamCandleMockContent, err := util.ReadFile(filepath)
	assert.Nil(t, err)
	contentReader := strings.NewReader(streamCandleMockContent)
	return contentReader
}

func decodeFromReader(t *testing.T, jsonToDecode *strings.Reader, output interface{}) {
	err := json.NewDecoder(jsonToDecode).Decode(output)
	assert.Nil(t, err)
	assert.NotEmpty(t, output)
}

func testBigqueryRow(t *testing.T, row []bigquery.CandleRow, expectedRowCount int) {
	assert.NotEmpty(t, row)
	counterCandleRows := len(row)
	assert.Equal(t, expectedRowCount, counterCandleRows)
}

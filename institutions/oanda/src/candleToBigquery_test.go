package main

import (
	"encoding/json"
	"fmt"
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
	const expectedCandleRows = 5

	streamCandleMockContent, err := util.ReadFile(pathToMock + "streamCandles.json")
	assert.Nil(t, err)
	contentReader := strings.NewReader(streamCandleMockContent)

	err = json.NewDecoder(contentReader).Decode(&mockCandleResponse)
	assert.Nil(t, err)
	assert.NotEmpty(t, mockCandleResponse)

	bigqueryCandleRows := convertCandlesToBigquery(mockCandleResponse)
	assert.NotEmpty(t, bigqueryCandleRows)
	counterCandleRows := len(bigqueryCandleRows)
	fmt.Printf("%+v", bigqueryCandleRows)
	assert.Equal(t, expectedCandleRows, counterCandleRows)

	bigqueryMockContent, err := util.ReadFile(pathToMock + "bigqueryCandleFromStreamCandle.json")
	assert.Nil(t, err)
	assert.NotEmpty(t, bigqueryMockContent)
	bigqueryMockReader := strings.NewReader(bigqueryMockContent)

	var expectedBigqueryCandle []bigquery.CandleRow
	err = json.NewDecoder(bigqueryMockReader).Decode(&expectedBigqueryCandle)
	assert.Nil(t, err)
	assert.NotEmpty(t, mockCandleResponse)

	assert.Equal(t, bigqueryCandleRows, bigqueryCandleRows)

}

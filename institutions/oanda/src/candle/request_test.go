package candle

import (
	"fmt"
	"testing"

	"github.com/pkg/errors"
	"github.com/tj/assert"
)

func Test_makeURL(t *testing.T) {
	input := mockInputEntry("adomain.com")
	expectedURL := getExpectedURL(input)
	actualURL := makeURL(input)

	assert.Equal(t, expectedURL, actualURL)
}

func mockInputEntry(domainName string) InputEntry {
	return InputEntry{
		APIDomainName: domainName,
		AccountID:     "1234",
		Instruments:   []string{"EUR_USD", "EUR_GBP"},
		Granularities: []string{"S5", "M1"},
		APIToken:      "atoken",
	}
}

func getExpectedURL(input InputEntry) string {
	// The format for OANDA Parameters are INSTRUMENT:GRANULARITY:BID_ASK_MEDIAN(BAM)
	return fmt.Sprintf("%s/v3/accounts/%s/candles/latest?candleSpecifications="+
		"%s:%s:BA,"+"%s:%s:BA,"+"%s:%s:BA,"+"%s:%s:BA",
		input.APIDomainName,
		input.AccountID,
		input.Instruments[0], input.Granularities[0],
		input.Instruments[1], input.Granularities[0],
		input.Instruments[0], input.Granularities[1],
		input.Instruments[1], input.Granularities[1],
	)
}

func Test_getStreamRequest(t *testing.T) {
	input := mockInputEntry("adomain.com")
	request, err := getStreamRequest(input)
	assert.Nil(t, err)

	autorizationToken := request.Header.Get("authorization")
	expectedAuthorizationToken := "Bearer " + input.APIToken
	assert.Equal(t, expectedAuthorizationToken, autorizationToken)

	actualRequestURL := request.URL.String()
	expectedURL := getExpectedURL(input)
	assert.Equal(t, expectedURL, actualRequestURL)
}

func Test_isConnectionResetByPeerError(t *testing.T) {
	err := errors.New("Connection reset by peer")
	assert.True(t, isConnectionResetByPeerError(err))
}

package candlefetcher

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
)

func getStreamRequest(input InputEntry) (*http.Request, error) {
	url := makeURL(input)

	request, err := util.MakeBearerGetRequest(url, input.APIToken)
	if err != nil {
		return nil, err
	}

	return request, nil
}

func makeURL(input InputEntry) string {
	parameters := makeURLParameters(input)
	URL := fmt.Sprintf("%s/v3/accounts/%s/candles/latest?candleSpecifications=%s",
		input.APIDomainName,
		input.AccountID,
		parameters)

	return URL
}

func makeURLParameters(input InputEntry) string {
	// The format for OANDA is INSTRUMENT:GRANULARITY:BID_ASK_MEDIAN(BAM)
	var parameters string

	for _, granularity := range input.Granularities {
		for _, instrument := range input.Instruments {
			parameters += instrument + ":" + granularity + ":BA" + ","
		}
	}

	parameters = strings.TrimSuffix(parameters, ",")
	return parameters
}

func sendRequest() (*http.Response, error) {
	resp, err := client.Do(request)
	if err != nil {
		return nil, err
	}
	return resp, nil
}

func isConnectionResetByPeerError(err error) bool {
	lowerErrorMessage := strings.ToLower(err.Error())
	if strings.Contains(lowerErrorMessage, "connection reset by peer") {
		return true
	}
	return false
}

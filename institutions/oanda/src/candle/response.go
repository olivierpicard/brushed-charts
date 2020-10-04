package candle

import (
	"io"
	"io/ioutil"
	"net/http"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/pkg/errors"
)

func extractExplicitHTTPError(resp *http.Response) error {
	body := util.TryReadingResponseBody(resp)
	errorMessage := "Error when sending a request to fetch latest candles price.\n"
	errorMessage += "Body: " + body
	return errors.New(errorMessage)
}

func tryKeepingConnectionAlive(response *http.Response) {
	if err := emptyResponseBody(response); err != nil {
		outputStream.err <- err
	}

	if err := closeResponseBody(response); err != nil {
		outputStream.err <- err
	}
}

func emptyResponseBody(response *http.Response) error {
	_, err := io.Copy(ioutil.Discard, response.Body)
	if err != nil {
		return errors.New("Can't read the entire response to empty the body\n" + err.Error())
	}
	return nil
}

func closeResponseBody(response *http.Response) error {
	err := response.Body.Close()
	if err != nil {
		return errors.New("Can't close the response body\n" + err.Error())
	}
	return nil
}

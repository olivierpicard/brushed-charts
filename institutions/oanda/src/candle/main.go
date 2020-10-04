package candle

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/pkg/errors"
)

var (
	client       *http.Client
	request      *http.Request
	outputStream OutputStream
)

// Stream fetch candles that match `granularity`
// and every given `instruments`
func Stream(_client *http.Client, inputEntry InputEntry) (OutputStream, error) {
	outputStream.init()
	if client = _client; client == nil {
		err := errors.New("Stream : Client can't be nil")
		return OutputStream{}, err
	}

	err := inputEntry.containsError()
	if err != nil {
		return OutputStream{}, err
	}

	request, err = getStreamRequest(inputEntry)
	if err != nil {
		return OutputStream{}, nil
	}

	go startRequestLoopAfterTime()
	return outputStream, nil
}

func startRequestLoopAfterTime() {
	duration, _ := time.ParseDuration("1s")
	ticker := time.NewTicker(duration)
	for range ticker.C {
		go requestLoop()
	}
}

func requestLoop() {
	resp, err := sendRequest()
	if err != nil {
		return
	}

	defer tryKeepingConnectionAlive(resp)

	if util.IsHTTPResponseError(resp) {
		extractedError := extractExplicitHTTPError(resp)
		outputStream.err <- extractedError
		return
	}

	structuredResponse, err := decodeJSONToStructuredResponse(resp)
	if err != nil {
		outputStream.fatal <- err
		return
	}
	if err := structuredResponse.isValid(); err != nil {
		outputStream.fatal <- err
	}

	outputStream.response <- structuredResponse
}

func decodeJSONToStructuredResponse(response *http.Response) (Response, error) {
	var structuredResponse Response
	err := json.NewDecoder(response.Body).Decode(&structuredResponse)
	if err != nil {
		errorWithMessage := errors.New("Can't parse the response " +
			"(returned when fetching the latest candles) to JSON struct\n" + err.Error())
		return Response{}, errorWithMessage
	}
	return structuredResponse, nil
}

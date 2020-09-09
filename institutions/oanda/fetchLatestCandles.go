package main

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/brushed-charts/backend/tools/cloudlogging"
)

type candlestickData struct {
	Open  string `json:"o"`
	High  string `json:"h"`
	Low   string `json:"l"`
	Close string `json:"c"`
}

type candlestick struct {
	Time     string          `json:"time"`
	Complete bool            `json:"complete"`
	Bid      candlestickData `json:"bid"`
	Ask      candlestickData `json:"ask"`
	Volume   int             `json:"volume"`
}

type candlestickResponse struct {
	Instrument  string        `json:"instrument"`
	Granularity string        `json:"granularity"`
	Candles     []candlestick `json:"candles"`
}

type latestCandlesArray struct {
	LatestCandles []candlestickResponse `json:"latestCandles"`
}

type candlesStream struct {
	candles chan latestCandlesArray
	warning chan error
	info    chan error
	err     chan error
}

func _initCandleStream() candlesStream {
	return candlesStream{
		candles: make(chan latestCandlesArray),
		warning: make(chan error),
		info:    make(chan error),
		err:     make(chan error),
	}
}

func fetchlatestCandles(accountID string, instruments *[]string, granularity string) (candlesStream, error) {
	cloudlogging.Init(projectID, serviceName)

	duration, err := time.ParseDuration(granularity)
	if err != nil {
		return candlesStream{}, err
	}

	url := buildURL(accountID, *instruments)
	stream := _initCandleStream()

	req, err := buildRequest(url)
	if err != nil {
		return candlesStream{}, err
	}

	client := &http.Client{}

	go func() {
		ticker := time.NewTicker(duration)
		for range ticker.C {
			go requestLoop(req, client, stream)
		}
	}()

	return stream, nil
}

func requestLoop(req *http.Request, client *http.Client, stream candlesStream) {
	var candles latestCandlesArray

	resp, err := sendRequest(req, client)
	if err != nil {
		manageCandleError(err, req, client, stream)
		return
	}
	fmt.Printf("%v\n\n", time.Now())

	isFatal, err := isFatalStatusCode(resp, stream)
	if err != nil {
		if isFatal {
			cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
			stream.err <- err
			return
		}
	}

	err = json.NewDecoder(resp.Body).Decode(&candles)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}

	_, err = io.Copy(ioutil.Discard, (*resp).Body)
	defer (*resp).Body.Close()

	if err != nil {
		err := fmt.Errorf("Couldn't read entire response to empty the body : %v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}
	fmt.Printf("%v\n\n", candles)

	stream.candles <- candles
	return
}

func buildURL(accountID string, instruments []string) string {
	url := apiURL + "/v3/accounts/" + accountID +
		"/candles/latest" + "?candleSpecifications="

	// The format for OANDA is INSTRUMENT:GRANULARITY:BID_ASK_MEDIAN(BAM)
	var candlesSpecification string

	// Add instrument before the candleSpecification and a ',' after
	for _, c := range instruments {
		candlesSpecification += c + ":S5:BA" + ","
	}

	candlesSpecification = strings.TrimSuffix(candlesSpecification, ",")
	url += candlesSpecification
	return url
}

func buildRequest(reqURL string) (*http.Request, error) {
	token := os.Getenv("OANDA_API_TOKEN")

	// Build the request and add authorization in the header
	req, err := http.NewRequest("GET", reqURL, nil)
	if err != nil {
		return nil, err
	}

	req.Header.Set("Authorization", "Bearer "+token)
	return req, nil
}

func sendRequest(req *http.Request, client *http.Client) (*http.Response, error) {
	resp, err := client.Do(req)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return nil, err
	}
	return resp, nil
}

func isFatalStatusCode(resp *http.Response, stream candlesStream) (bool, error) {
	if resp.StatusCode == 200 {
		return false, nil
	}

	body := tryReadingFailedResponse(resp)

	err := fmt.Errorf("Latest candles response return status code : %v "+
		"\nExtracted body: %v", resp.StatusCode, body)

	// 400 Status could involve user error like misspelling instrument
	// It not worth stopping the entire program for this. All others are fatal
	if resp.StatusCode != 400 {
		return true, err
	}

	return false, err
}

func tryReadingFailedResponse(resp *http.Response) string {
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return ""
	}
	return string(body)
}

func manageCandleError(err error, req *http.Request, client *http.Client, stream candlesStream) {
	if strings.Contains(err.Error(), "connection reset by peer") {
		// cloudlogging.ReportInfo(cloudlogging.EntryFromError(err))
		// stream.warning <- err
		// time.Sleep(time.Second)
		// requestLoop(req, client, stream)
	}
}

package main

import (
	"bufio"
	"encoding/json"
	"net/http"
	"os"
	"strings"

	"github.com/brushed-charts/backend/tools/cloudlogging"
)

type streamType string

const (
	heartBeat streamType = "HEARTBEAT"
	price     streamType = "PRICE"
)

type pricingStream struct {
	Type       streamType `json:"type"`
	Time       string     `json:"time"`
	Bid        string     `json:"closeoutBid"`
	Ask        string     `json:"closeoutAsk"`
	Tradeable  bool       `json:"tradeable"`
	Instrument string     `json:"instrument"`
}

func getPriceStream(accountID string, instruments []string, channel chan pricingStream) {
	cloudlogging.Init(projectID, serviceName)
	req, err := buildRequest(accountID, instruments)
	if err != nil {
		return
	}

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return
	}

	reader := bufio.NewReader(resp.Body)
	for {
		price, err := readStream(resp, reader)
		if err != nil {
			return
		}
		if price.Type == heartBeat {
			continue
		}
		channel <- price
	}
}

func buildRequest(accountID string, instruments []string) (*http.Request, error) {
	token := os.Getenv("OANDA_API_TOKEN")
	urlPricingStream := streamURL + "/v3/accounts/" + accountID +
		"/pricing/stream" + "?instruments="

	// Add Instrument to URL
	for _, s := range instruments {
		urlPricingStream += s + ","
	}
	// Remove the last ',' in the URL
	urlPricingStream = strings.TrimSuffix(urlPricingStream, ",")

	// Build the request and add authorization in the header
	req, err := http.NewRequest("GET", urlPricingStream, nil)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return nil, err
	}
	req.Header.Add("Authorization", "Bearer "+token)
	return req, nil
}

func readStream(resp *http.Response, reader *bufio.Reader) (pricingStream, error) {
	var price pricingStream

	// Read the incomming line until '\n'
	line, err := reader.ReadString('\n')
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return pricingStream{}, err
	}

	// Convert string to reader to be read by json decoder
	r := strings.NewReader(line)

	// decode string reader into pricingStream
	err = json.NewDecoder(r).Decode(&price)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return pricingStream{}, err
	}

	return price, nil
}

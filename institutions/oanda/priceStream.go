package main

import (
	"bufio"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strings"
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

func listenStream(accountID string, instruments []string, channel chan pricingStream) {
	req := buildRequest(accountID, instruments)

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		reportError(err)
		log.Fatalln(err)
	}

	reader := bufio.NewReader(resp.Body)
	for {
		price := readStream(resp, reader)
		if price.Type == heartBeat {
			continue
		}
		channel <- price
	}
}

func buildRequest(accountID string, instruments []string) *http.Request {
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
		reportError(err)
		log.Fatalln(err)
	}
	req.Header.Add("Authorization", "Bearer "+token)
	return req
}

func readStream(resp *http.Response, reader *bufio.Reader) pricingStream {
	var price pricingStream

	// Read the incomming line until '\n'
	line, err := reader.ReadString('\n')
	if err != nil {
		reportError(err)
		log.Fatalln(err)
	}

	// Convert string to reader to be read by json decoder
	r := strings.NewReader(line)

	// decode string reader into pricingStream
	err = json.NewDecoder(r).Decode(&price)
	if err != nil {
		reportError(err)
		log.Fatalln(err)
	}

	return price
}

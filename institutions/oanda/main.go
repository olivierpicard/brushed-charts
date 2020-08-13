package main

import (
	"fmt"
	"log"
	"os"
)

const serviceName = "institution/oanda"
const projectID = "brushed-charts"
const url = "https://api-fxpractice.oanda.com/v3/accounts"
const streamURL = "https://stream-fxpractice.oanda.com"
const envTokenName = "OANDA_API_TOKEN"
const bigQueryDataset = "oanda"

func main() {
	// Check if env variable is present
	if _, b := os.LookupEnv(envTokenName); !b {
		os.Setenv(envTokenName, getToken())
	}

	id, err := getAccountID()
	if err != nil {
		return
	}

	stream := make(chan pricingStream)
	errChan := make(chan error)

	go getPriceStream(id, []string{"EUR_USD", "EUR_CAD"}, stream, errChan)
	go insertStreamingBigQueryRow(stream, errChan)

	var counter int
	for {
		select {
		case <-stream:
			counter++
		case e := <-errChan:
			close(stream)
			close(errChan)
			log.Fatalf("%v\n", e)
		}
		fmt.Println(counter)
	}
}

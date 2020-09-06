package main

import (
	"fmt"
	"log"
	"os"
)

const serviceName = "institution/oanda"
const projectID = "brushed-charts"
const envTokenName = "OANDA_API_TOKEN"
const bigQueryDataset = "oanda"

var apiURL string

func main() {
	apiURL = os.Getenv("OANDA_API_URL")
	setAPIKeyEnvVariable()

	id, err := getAccountID()
	if err != nil {
		log.Fatal("Can't retrieve the accound ID")
	}

	instruments := []string{"EUR_USD", "EUR_CAD"}

	stream, err := fetchlatestCandles(id, instruments, "1s")
	if err != nil {
		log.Fatal(err)
	}

	for {
		readResult(stream)
	}
}

func setAPIKeyEnvVariable() {
	// Check for OANDA API KEY
	if _, b := os.LookupEnv(envTokenName); !b {
		token, err := getToken()
		if err != nil {
			log.Fatal(err)
		}

		// Set OANDA API KEY in env variable
		os.Setenv(envTokenName, token)
	}
}

func readResult(stream candlesStream) {
	select {
	case cand := <-stream.candles:
		bq := cand.parseForBigQuery()
		fmt.Printf("%+v\n\n", bq)
	case err := <-stream.err:
		log.Fatalln(err)
	}
}

package main

import (
	"fmt"
	"log"
	"os"

	"github.com/brushed-charts/backend/tools/cloudlogging"
)

const serviceName = "institution/oanda"
const projectID = "brushed-charts"
const envTokenName = "OANDA_API_TOKEN"
const bigQueryDataset = "oanda"

var apiURL string
var bqTableNameShortterm string
var bqTableNameArchive string

func main() {
	apiURL = os.Getenv("OANDA_API_URL")
	bqTableNameShortterm = os.Getenv("BIGQUERY_SHORTTERM_TABLENAME")
	bqTableNameArchive = os.Getenv("BIGQUERY_ARCHIVE_TABLENAME")

	setAPIKeyEnvVariable()

	err := checkEnvVariable()
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		log.Fatalf("%v", err)
	}

	id, err := getAccountID()
	if err != nil {
		log.Fatal("Can't retrieve the accound ID")
	}

	instruments := []string{"EUR_USD", "EUR_CAD"}

	stream, err := fetchlatestCandles(id, instruments, "1s")
	if err != nil {
		log.Fatal(err)
	}

	go streamToBigQuery(stream.candles)
	for err := range stream.err {
		log.Fatalf("%v", err)
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

func checkEnvVariable() error {
	baseErr := "Environnement variables are empty : "
	errSentence := baseErr
	if apiURL == "" {
		errSentence += "\napiURL"
	}

	if bqTableNameArchive == "" {
		errSentence += "\nbqTableNameArchive"
	}

	if bqTableNameShortterm == "" {
		errSentence += "\nbqTableNameShortterm"
	}

	if os.Getenv(envTokenName) == "" {
		errSentence += "\n" + envTokenName
	}

	if errSentence != baseErr {
		err := fmt.Errorf(errSentence)
		return err
	}

	return nil
}

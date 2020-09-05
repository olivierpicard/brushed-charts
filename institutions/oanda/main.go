package main

import (
	"log"
	"os"
)

const serviceName = "institution/oanda"
const projectID = "brushed-charts"
const envTokenName = "OANDA_API_TOKEN"
const bigQueryDataset = "oanda"

var apiURL string

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

func main() {
	apiURL = os.Getenv("OANDA_API_URL")
	setAPIKeyEnvVariable()

	id, err := getAccountID()
	if err != nil {
		log.Fatal("Can't retrieve the accound ID")
	}

	instruments := []string{"EUR_USD", "EUR_CAD"}

	_, err = fetchlatestCandles(id, instruments)
	if err != nil {
		log.Fatal(err)
	}

	// go insertStreamingBigQueryRow(stream, errChan)

	/* var counter int
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
	} */
}

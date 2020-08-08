package main

import (
	"fmt"
	"os"
)

const serviceName = "Institution Oanda"
const projectID = "brushed-charts"
const url = "https://api-fxpractice.oanda.com/v3/accounts"
const streamURL = "https://stream-fxpractice.oanda.com"
const envTokenName = "OANDA_API_TOKEN"

func main() {
	// Check if env variable is present
	if _, b := os.LookupEnv(envTokenName); !b {
		os.Setenv(envTokenName, getToken())
	}

	id := getAccountID()
	stream := make(chan pricingStream)
	go getPriceStream(id, []string{"EUR_USD", "EUR_CAD"}, stream)
	for s := range stream {
		fmt.Printf("%#v\n", s)
	}
}

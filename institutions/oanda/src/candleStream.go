package main

import (
	"net/http"
	"regexp"

	"github.com/brushed-charts/backend/institutions/oanda/src/candle"
	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/brushed-charts/backend/lib/cloudlog"
)

func getCandleStream() candle.OutputStream {
	instruments := readWatchlistInstruments()
	inputArgs := makeCandleInputEntry(instruments)
	outputStream, err := candle.Stream(&http.Client{}, inputArgs)
	if err != nil {
		cloudlog.Panic(err)
	}

	return outputStream
}

func readWatchlistInstruments() []string {
	watchlistContent, err := util.ReadFile(watchlistPath)
	if err != nil {
		cloudlog.Panic(err)
	}

	instruments, err := parseWatchlist(watchlistContent)
	if err != nil {
		cloudlog.Panic(err)
	}

	return instruments
}

func parseWatchlist(stringWatchlist string) ([]string, error) {
	re := regexp.MustCompile(`(?mi)^[[:word:]]+`)
	instruments := re.FindAllString(stringWatchlist, -1)
	return instruments, nil
}

func makeCandleInputEntry(instruments []string) candle.InputEntry {
	inputArguments := candle.InputEntry{
		Granularities: granularities,
		Instruments:   instruments,
		APIDomainName: oandaAPIURL,
		APIToken:      oandaAPIToken,
		AccountID:     accountID,
	}

	return inputArguments
}

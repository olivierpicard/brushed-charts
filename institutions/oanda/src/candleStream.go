package main

import (
	"net/http"
	"regexp"

	"github.com/brushed-charts/backend/institutions/oanda/src/candlefetcher"
	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/brushed-charts/backend/lib/cloudlog"
	"github.com/pkg/errors"
)

func getCandleStream() candlefetcher.OutputStream {
	instruments := readWatchlistInstruments()
	inputArgs := makeCandleInputEntry(instruments)
	outputStream, err := candlefetcher.Stream(&http.Client{}, inputArgs)
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
	if instruments == nil {
		err := errors.New("Error when parsing watchlist. Format may be incorrect or the file may be empty")
		return nil, err
	}
	return instruments, nil
}

func makeCandleInputEntry(instruments []string) candlefetcher.InputEntry {
	inputArguments := candlefetcher.InputEntry{
		Granularities: granularities,
		Instruments:   instruments,
		APIDomainName: oandaAPIURL,
		APIToken:      oandaAPIToken,
		AccountID:     accountID,
	}

	return inputArguments
}

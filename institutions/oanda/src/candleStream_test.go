package main

import (
	"log"
	"testing"

	"github.com/tj/assert"
)

func initForCandleStreamTest() {
	if accountID != "" {
		return
	}

	initGlobalVariables()
	accountID = getOandaAccountID()
	if err := recover(); err != nil {
		log.Panicf("Can't start the test, because can't get oanda accountID")
	}
}

func TestIntegration_getCandleStream(t *testing.T) {
	initForCandleStreamTest()
	candleOutput := getCandleStream()
	instrumentCount := len(readWatchlistInstruments())
	granularitiyCount := len(granularities)
	expectedCandleCount := instrumentCount * granularitiyCount

	stream := <-candleOutput.Stream
	instruments := stream.LatestCandles
	assert.Equal(t, expectedCandleCount, len(instruments))
}

func Test_getCandleStream_NoWatchlist(t *testing.T) {
	initForCandleStreamTest()
	rescuedWatchlistPath := watchlistPath
	watchlistPath = ""
	defer func() { watchlistPath = rescuedWatchlistPath }()

	funcThatShouldPanic := func() { getCandleStream() }
	assert.Panics(t, funcThatShouldPanic)
}

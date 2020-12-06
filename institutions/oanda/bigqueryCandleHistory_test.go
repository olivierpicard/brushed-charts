package main

import (
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestBigqueryCandleHistory(t *testing.T) {
	var history = bigqueryCandleHistory{}

	t.Log("Testing on empty candle history")

	news := createExample1()
	uniqs := bigqueryKeepUniqueCandleRow(history, news)
	if !cmp.Equal(news, uniqs) {
		t.Fatal("KeepUniqueRow doesn't return the same as example1")
	}

	history.update(uniqs)
	cast := []bigQueryCandleRow(history)
	if !cmp.Equal(cast, news) {
		t.Fatal("Update history is not the same as example 1")
	}

	t.Log("testing on filled history")

	news = createExample2()
	uniqs = bigqueryKeepUniqueCandleRow(history, news)
	uniqsShould := append(news[:1], news[2:]...)
	if !cmp.Equal(uniqs, uniqsShould) {
		t.Fatal("Unique rows should be the same as input but with 1 item in less")
	}

	history.update(uniqs)
	cast = []bigQueryCandleRow(history)
	if !cmp.Equal(cast, historyExample2()) {
		t.Fatal("Update history is not the same as example 2")
	}

	t.Log("testing on filled history and introcing a new item + different time")
	news = createExample3()
	uniqs = bigqueryKeepUniqueCandleRow(history, news)
	if !cmp.Equal(uniqs, uniqueRowExample3()) {
		t.Fatal("KeepUniqueCandleRow is not equal to the demonstration example 3")
	}

	history.update(uniqs)
	histShould := historyExample3()
	for _, h := range history {
		exist := false
		for _, hs := range histShould {
			if cmp.Equal(hs, h) {
				exist = true
				break
			}
		}
		if !exist {
			t.Fatal("Update history is not equal to the demonstration example 3")
		}
	}

}

func createExample1() []bigQueryCandleRow {
	return []bigQueryCandleRow{
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:10:55.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:10:55.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:10:55.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:10:55.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
	}
}

func createExample2() []bigQueryCandleRow {
	return []bigQueryCandleRow{
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:10:55.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
		// Minute
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
	}
}

func createExample3() []bigQueryCandleRow {
	return []bigQueryCandleRow{
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "EUR_USD",
			Date:        "2020-09-16T13:11:05.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:05.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
		// Minute
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
	}
}

func historyExample2() []bigQueryCandleRow {
	return []bigQueryCandleRow{
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:10:55.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
		// Minute
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
	}
}

func uniqueRowExample3() []bigQueryCandleRow {
	return []bigQueryCandleRow{
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "EUR_USD",
			Date:        "2020-09-16T13:11:05.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:05.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
		// Minute
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
	}
}

func historyExample3() []bigQueryCandleRow {
	return []bigQueryCandleRow{
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "EUR_USD",
			Date:        "2020-09-16T13:11:05.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:05.000000000Z",
			Granularity: "S5",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
		// Minute
		{
			Instrument:  "NAS100_USD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 11474, High: 11476.5, Low: 11474, Close: 11476.5},
			Ask:         bigQueryCandleData{Open: 11475.7, High: 11478.2, Low: 11475.7, Close: 11478.2},
			Volume:      4,
		},
		{
			Instrument:  "AU200_AUD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5956.6, High: 5956.6, Low: 5956.6, Close: 5956.6},
			Ask:         bigQueryCandleData{Open: 5960.8, High: 5960.8, Low: 5960.8, Close: 5960.8},
			Volume:      1,
		},
		{
			Instrument:  "FR40_EUR",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 5046.6, High: 5046.6, Low: 5046, Close: 5046.1},
			Ask:         bigQueryCandleData{Open: 5047.5, High: 5047.5, Low: 5047.1, Close: 5047.1},
			Volume:      4,
		},
		{
			Instrument:  "HK33_HKD",
			Date:        "2020-09-16T13:11:00.000000000Z",
			Granularity: "M1",
			Bid:         bigQueryCandleData{Open: 24673.6, High: 24673.6, Low: 24673.6, Close: 24673.6},
			Ask:         bigQueryCandleData{Open: 24678.6, High: 24678.6, Low: 24678.6, Close: 24678.6},
			Volume:      1,
		},
	}
}

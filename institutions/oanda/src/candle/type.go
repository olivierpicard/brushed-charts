package candle

import (
	"strings"

	"github.com/pkg/errors"
)

// OHLC (open, high, low, close) represent the most basic
// candlestick's information
type OHLC struct {
	Open  string `json:"o"`
	High  string `json:"h"`
	Low   string `json:"l"`
	Close string `json:"c"`
}

// StockAtTime show for a precise time, the volume,
// the bid and ask prices, and if a candlestick is complete
type StockAtTime struct {
	Time     string `json:"time"`
	Complete bool   `json:"complete"`
	Bid      OHLC   `json:"bid"`
	Ask      OHLC   `json:"ask"`
	Volume   int    `json:"volume"`
}

// ResponsePerInstrumentAndGranularity is a response returned by
// oanda that match a specific instrument or granularity
type ResponsePerInstrumentAndGranularity struct {
	Instrument  string        `json:"instrument"`
	Granularity string        `json:"granularity"`
	Candles     []StockAtTime `json:"candles"`
}

// Response is a structured response return by oanda, that
// include every instruments and granularities asked
type Response struct {
	LatestCandles []ResponsePerInstrumentAndGranularity `json:"latestCandles"`
}

// OutputStream communicate about the state
// of this package in real time.
// It could indicate the latest prices fetched, an error or a fatal error
type OutputStream struct {
	response chan Response
	err      chan error
	fatal    chan error
}

func (out *OutputStream) init() {
	out.response = make(chan Response)
	out.err = make(chan error)
	out.fatal = make(chan error)
}

// InputEntry correspond to data that must
// be delivered before fetching the result
type InputEntry struct {
	Instruments   []string
	Granularities []string
	AccountID     string
	APIDomainName string
}

func (in *InputEntry) containError() error {
	var err error
	err = checkSliceValidity(in.Instruments)
	if err != nil {
		return err
	}

	err = checkSliceValidity(in.Granularities)
	if err != nil {
		return err
	}

	if in.AccountID == "" {
		return errors.New("Account ID can't be an empty")
	}
	if in.APIDomainName == "" && strings.ContainsAny(in.APIDomainName, "/&?") {
		return errors.New("APIDomainName can't be empty. " +
			"Nor describe a path. " +
			"Characters '/','&','?' are also forbidden")
	}

	return nil
}

func checkSliceValidity(slice []string) error {
	if slice == nil {
		return errors.New("The given slice is nil")
	}
	if len(slice) == 0 {
		return errors.New("The given slice is empty")
	}
	for _, data := range slice {
		if data == "" {
			return errors.New("Empty strings are not allowed")
		}
	}
	return nil
}

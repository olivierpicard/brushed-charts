package main

import (
	"os"
	"strconv"
	"testing"
	"time"
)

var id string

func TestGetToken(t *testing.T) {
	token := getToken()
	os.Setenv(envTokenName, token)

	if token == "" {
		t.Error("token can't be retrieved")
	}
}

func TestGetAccountID(t *testing.T) {
	var err error
	id, err = getAccountID()
	if err != nil {
		t.FailNow()
	}
}

func validatePricingStreamData(s *pricingStream, t *testing.T) {
	if s.Type != price {
		t.Errorf("type of the streaming price should be equal to \"PRICE\"")
	}

	ask, err := strconv.ParseFloat(s.Ask, 64)
	bid, err := strconv.ParseFloat(s.Bid, 64)
	if err != nil {
		t.Error(err)
	}
	if ask == 0 || bid == 0 {
		t.Errorf("Ask or Bid price can't be equal to zero")
	}
}

func TestPriceStream(t *testing.T) {
	stream := make(chan pricingStream)
	errChan := make(chan error)
	instruments := []string{"EUR_USD", "EUR_CAD"}
	go getPriceStream(id, instruments, stream, errChan)

	res := make(map[string]pricingStream)

	for len(res) < 2 {
		select {
		case s := <-stream:
			validatePricingStreamData(&s, t)
			res[s.Instrument] = s

		case <-time.After(30 * time.Second):
			t.Errorf("Timeout pricing stream. It take too long to get a response")
			return
		}
	}
}

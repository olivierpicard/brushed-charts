package main

import (
	"net/http"

	"github.com/brushed-charts/backend/institutions/oanda/src/account"
	"github.com/brushed-charts/backend/lib/cloudlog"
	"github.com/pkg/errors"
)

var (
	accountID     string
	granularities = []string{"S5", "M1", "H1", "D"}
)

func main() {
	initGlobalVariables()
	accountID = getOandaAccountID()
	outputStream := getCandleStream()
	go saveCandleStreamToBigquery(outputStream.Stream)
}

func getOandaAccountID() string {
	oandaAccountID, err := account.GetAccountID(&http.Client{}, oandaAPIToken, oandaAPIURL)
	if err != nil {
		cloudlog.Panic(err)
	}

	if oandaAccountID == "" {
		err = errors.New("Oanda account ID is empty")
		cloudlog.Panic(err)
	}
	return oandaAccountID
}

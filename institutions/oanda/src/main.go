package main

import (
	"net/http"

	"github.com/brushed-charts/backend/institutions/oanda/src/account"
	"github.com/brushed-charts/backend/lib/cloudlog"
	"github.com/pkg/errors"
)

func main() {
	initGlobalVariables()
	_, err := getOandaAccountID()
	if err != nil {
		cloudlog.Panic(err)
	}
}

func getOandaAccountID() (string, error) {
	oandaAccountID, err := account.GetAccountID(&http.Client{})
	if err != nil {
		return "", err
	}

	if oandaAccountID == "" {
		err = errors.New("Oanda account ID is empty")
		return "", err
	}
	return oandaAccountID, nil
}

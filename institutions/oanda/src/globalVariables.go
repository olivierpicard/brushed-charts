package main

import (
	"fmt"
	"os"

	"github.com/brushed-charts/backend/institutions/oanda/src/secret"
	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/brushed-charts/backend/lib/cloudlog"
	"github.com/pkg/errors"
)

const (
	serviceName           = "institution/oanda"
	projectID             = "brushed-charts"
	minRefreshRate        = "1s"
	envKeyEnvironmentMode = "BRUSHED-CHARTS-ENVIRONMENT"
)

var (
	oandaAPIToken    string
	oandaAPIURL      string
	bqPriceShortterm string
	bqPriceArchive   string
	bigQueryDataset  string
	watchlistPath    string
	latestCandlePath string
)

func initGlobalVariables() {
	oandaAPIToken = getOandaTokenDependingOnEnvironment()
	oandaAPIURL = getEnvironmentVariables("OANDA_API_URL")
	bqPriceShortterm = getEnvironmentVariables("OANDA_BIGQUERY_SHORTTERM_TABLENAME")
	bqPriceArchive = getEnvironmentVariables("OANDA_BIGQUERY_ARCHIVE_TABLENAME")
	bigQueryDataset = getEnvironmentVariables("OANDA_BIGQUERY_DATASET")
	watchlistPath = getEnvironmentVariables("OANDA_WATCHLIST_PATH")
	latestCandlePath = getEnvironmentVariables("OANDA_LATEST_CANDLE_PATH")
}

func getOandaTokenDependingOnEnvironment() string {
	if util.IsInDevelopmentEnvironment() {
		// We load oanda token api from environment variables
		// in dev mode to speed up the loading (a sort of caching)
		return getEnvironmentVariables("OANDA_API_TOKEN")
	}

	token, err := getOandaTokenFromSecret()
	if err != nil {
		cloudlog.Panic(err)
	}

	return token
}

func getOandaTokenFromSecret() (string, error) {
	apiToken, err := secret.GetOandaAPIToken(projectID)
	if err != nil {
		return "", err
	}
	return apiToken, nil
}

func getEnvironmentVariables(variableName string) string {
	variableContent, isExisting := os.LookupEnv(variableName)

	if isExisting && variableContent != "" {
		return variableContent
	}

	errorMessage := fmt.Sprintf(
		"PANIC : Environment variable \"%s\" doesn't exist or is empty.",
		variableName)

	err := errors.New(errorMessage)
	cloudlog.Panic(err)
	return ""
}

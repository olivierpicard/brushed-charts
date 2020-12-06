package main

import (
	"os"
	"testing"

	"github.com/brushed-charts/backend/lib/testutil"
	"github.com/tj/assert"
)

func init() {
	content, isExisting := os.LookupEnv(envKeyEnvironmentMode)
	if content == "" || !isExisting {
		os.Setenv(envKeyEnvironmentMode, "dev")
	}

}

func Test_getEnvironmentVariables_WithEmptyVars_WillPanic(t *testing.T) {
	functionThatCanPanic := func() {
		// Capture log to not polute the output with expected errors
		testutil.ExcuteFunctionToCaptureLog(func() {
			getEnvironmentVariables("NON_EXISTING_VARIABLE_NAME")
		})
	}
	assert.Panics(t, functionThatCanPanic)
}

func Test_getEnvironmentVariables_WithEmptyVars_Log(t *testing.T) {
	defer func() { recover() }()
	envvariableName := "NON_EXISTING_VARIABLE_NAME"
	expectedLog := "Environment variable " + envKeyEnvironmentMode + " doesn't exist or is empty."
	capturedLog := testutil.ExcuteFunctionToCaptureLog(func() {
		getEnvironmentVariables(envvariableName)
	})
	assert.Equal(t, expectedLog, capturedLog)
}

func Test_getEnvironmentVariables(t *testing.T) {
	envVarName := "A_VAR_NAME_TO_TEST"
	expectedEnvValue := "a test value"

	os.Setenv(envVarName, expectedEnvValue)
	defer os.Setenv(envVarName, "")

	actualEnvValue := getEnvironmentVariables(envVarName)
	assert.Equal(t, expectedEnvValue, actualEnvValue)
}

func Test_getOandaTokenDependingOnEnvironment_DevMode(t *testing.T) {
	mockToken := "random_token"
	envName := "OANDA_API_TOKEN"

	rescuedToken := os.Getenv(envName)
	os.Setenv(envName, mockToken)
	defer os.Setenv(envName, rescuedToken)

	token := getOandaTokenDependingOnEnvironment()
	assert.Equal(t, mockToken, token)
}

// Environment variable "GOOGLE_APPLICATION_CREDENTIALS" is needed to run
// this test. Else it will fait
func TestIntegration_getOandaTokenDependingOnEnvironment_WithSecret_NotDevMode(t *testing.T) {
	previousEnvMode := os.Getenv(envKeyEnvironmentMode)
	os.Setenv(envKeyEnvironmentMode, "integration_test")
	defer os.Setenv(envKeyEnvironmentMode, previousEnvMode)

	var token string
	functionExpectedToNotPanicking := func() { token = getOandaTokenDependingOnEnvironment() }

	assert.NotPanics(t, functionExpectedToNotPanicking)
	assert.NotEmpty(t, token)
	assert.Contains(t, token, "-")
}

func Test_InitGlobalVariables(t *testing.T) {
	initGlobalVariables()
	assert.NotEmpty(t, oandaAPIToken)
	assert.NotEmpty(t, oandaAPIURL)
	assert.NotEmpty(t, bqPriceShortterm)
	assert.NotEmpty(t, bqPriceArchive)
	assert.NotEmpty(t, bigQueryDataset)
	assert.NotEmpty(t, watchlistPath)
	assert.NotEmpty(t, latestCandlePath)
}

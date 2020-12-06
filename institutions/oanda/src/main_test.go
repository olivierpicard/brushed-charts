package main

import (
	"os"
	"testing"

	"github.com/tj/assert"
)

func TestIntegration_AccountID_NotDevEnv(t *testing.T) {
	previousEnvMode := os.Getenv(envKeyEnvironmentMode)
	os.Setenv(envKeyEnvironmentMode, "integration_test")
	defer os.Setenv(envKeyEnvironmentMode, previousEnvMode)

	testAccountID(t)
}
func TestIntegration_AccountID_DevEnv(t *testing.T) {
	previousEnvMode := os.Getenv(envKeyEnvironmentMode)
	os.Setenv(envKeyEnvironmentMode, "dev")
	defer os.Setenv(envKeyEnvironmentMode, previousEnvMode)

	testAccountID(t)
}

func Test_AccountID_NoAPIToken(t *testing.T) {
	rescuedAPIToken := oandaAPIToken
	oandaAPIToken = ""
	defer func() { oandaAPIToken = rescuedAPIToken }()
	funcThatShouldPanic := func() { getOandaAccountID() }
	assert.Panics(t, funcThatShouldPanic)
}

func testAccountID(t *testing.T) {
	var accountID string
	funcThatShouldNotPanic := func() { accountID = getOandaAccountID() }
	assert.NotPanics(t, funcThatShouldNotPanic)
	assert.NotEmpty(t, accountID)
}

package main

import (
	"os"
	"testing"

	"github.com/tj/assert"
)

func init() {
	os.Setenv(envKeyEnvironmentMode, "dev")
}

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

func testAccountID(t *testing.T) {
	accountID, err := getOandaAccountID()
	assert.Nil(t, err)
	assert.NotEmpty(t, accountID)
}

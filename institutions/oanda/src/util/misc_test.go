package util

import (
	"os"
	"testing"

	"github.com/tj/assert"
)

func Test_IsInDevelopmentEnvironment_Dev(t *testing.T) {
	parametrableTestIsInDevelopmentEnvironment(t, "dev", true)
}

func Test_IsInDevelopmentEnvironment_Empty(t *testing.T) {
	parametrableTestIsInDevelopmentEnvironment(t, "", false)
}

func Test_IsInDevelopmentEnvironment_Test(t *testing.T) {
	parametrableTestIsInDevelopmentEnvironment(t, "test", false)
}

func parametrableTestIsInDevelopmentEnvironment(t *testing.T, desiredMode string, expectedResult bool) {
	variableName := "BRUSHED-CHARTS-ENVIRONMENT"
	previousMode := os.Getenv(variableName)
	defer os.Setenv(variableName, previousMode)

	os.Setenv(variableName, desiredMode)
	isInDevMode := IsInDevelopperEnvironment()
	assert.Equal(t, expectedResult, isInDevMode)
}

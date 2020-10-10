package util

import (
	"os"
	"strings"
	"testing"

	"github.com/tj/assert"
)

const (
	fileToRead = "/etc/brushed-charts/mock/fileToRead"
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
	isInDevMode := IsInDevelopmentEnvironment()
	assert.Equal(t, expectedResult, isInDevMode)
}

func Test_readfile(t *testing.T) {
	content, err := ReadFile(fileToRead)
	assert.Nil(t, err)
	assert.NotEmpty(t, content)
	assert.Contains(t, content, "file to read")
}

func Test_readfile_NotExistingFile(t *testing.T) {
	content, err := ReadFile("/etc/brushed-charts/mock/notexistingfile")
	assert.NotNil(t, err)
	assert.Contains(t, strings.ToLower(err.Error()), "can't read")
	assert.Empty(t, content)

}

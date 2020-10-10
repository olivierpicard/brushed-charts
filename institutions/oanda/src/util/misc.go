package util

import (
	"io/ioutil"
	"os"

	"github.com/pkg/errors"
)

// IsInDevelopmentEnvironment return true if
// the environment variable BRUSHED-CHARTS-ENVIRONMENT equal "dev"
func IsInDevelopmentEnvironment() bool {
	envVarName := "BRUSHED-CHARTS-ENVIRONMENT"
	mode, _ := os.LookupEnv(envVarName)
	return mode == "dev"
}

// ReadFile read the file given by `filepath`
func ReadFile(filePath string) (string, error) {
	bytes, err := ioutil.ReadFile(filePath)
	if err != nil {
		err := errors.New("Can't read the given file (" + filePath + ")")
		return "", err
	}
	return string(bytes), err
}

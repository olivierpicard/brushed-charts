package util

import (
	"fmt"
	"io/ioutil"
	"os"
	"time"

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

// IsDateGreater return true if strDate1 > strDate2 else return false.
// return an error if strDate is not in RFC3339Nano format
func IsDateGreater(strDate1 string, strDate2 string) (bool, error) {
	parseErr := "Can't parse the given date"
	dt1, err := time.Parse(time.RFC3339Nano, strDate1)
	if err != nil {
		err := fmt.Errorf("%v : %v", parseErr, err)
		return false, err
	}

	dt2, err := time.Parse(time.RFC3339Nano, strDate2)
	if err != nil {
		err := fmt.Errorf("%v : %v", parseErr, err)
		return false, err
	}

	if dt1.After(dt2) {
		return true, nil
	}

	return false, nil
}

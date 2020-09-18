package main

import (
	"fmt"
	"time"
)

// DateGreater return true if strDate1 > strDate2 else return false.
// return an error if strDate is not in RFC3339Nano format
func DateGreater(strDate1 string, strDate2 string) (bool, error) {
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

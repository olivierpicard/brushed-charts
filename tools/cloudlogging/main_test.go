package cloudlogging

import (
	"fmt"
	"testing"
)

var errTest = fmt.Errorf("A report test")

func init() {
	Init("brushed-charts", "cloudlogging_test")
}

func TestCritical(t *testing.T) {
	err := ReportCritical(EntryFromError(errTest))
	if err != nil {
		t.FailNow()
	}

}

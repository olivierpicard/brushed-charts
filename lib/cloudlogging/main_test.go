package cloudlogging

import (
	"fmt"
	"testing"
)

var errTest = fmt.Errorf("A report test")

func init() {
	Init("brushed-charts", "cloudlogging_test")
}

func TestWriteDebug(t *testing.T) {
	err := ReportDebug(EntryFromError(errTest))
	if err != nil {
		t.FailNow()
	}
}

func TestWriteInfo(t *testing.T) {
	err := ReportInfo(EntryFromError(errTest))
	if err != nil {
		t.FailNow()
	}
}

func TestWriteWarning(t *testing.T) {
	err := ReportWarning(EntryFromError(errTest))
	if err != nil {
		t.FailNow()
	}
}

func TestWriteCritical(t *testing.T) {
	err := ReportCritical(EntryFromError(errTest))
	if err != nil {
		t.FailNow()
	}
}

func TestWriteEmergency(t *testing.T) {
	err := ReportEmergency(EntryFromError(errTest))
	if err != nil {
		t.FailNow()
	}
}

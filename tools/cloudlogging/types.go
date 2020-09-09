package cloudlogging

import (
	"fmt"

	"cloud.google.com/go/logging"
)

// Severity is an unified type to group constants of the same type,
// like Info, Warning, Fatal
type Severity uint8

// errorSpec is an internal struct to transmit information in the
// correct format, to one google service
type errorSpec struct {
	ErrorString string `json:"errorstring"`
	ServiceName string `json:"servicename"`
	Message     string `json:"message"`
	Stack       string `json:"stack"`
}

// LogEntry is a struct uses to transmit precise
// information about the error.
type LogEntry struct {
	Error    error
	Message  string
	Stack    []byte
	Severity Severity
	IsQuiet  bool
}

// Type of the log. Also use to dispatch between services
const (
	// A routine information like perf, new subsctiption, a common change
	Info Severity = 0
	// A minor problem, service can continue to run normally
	Warning Severity = 1
	// A severe problem that could lead to service interruption
	Critical Severity = 2
	// A trace message
	Debug Severity = 3
	// A service is unusable
	Emergency Severity = 4
)

// Convert an internal severity model to Google Logging Severity format
func (logType *Severity) toGoogleSeverity() logging.Severity {
	var severity logging.Severity

	switch *logType {
	case Info:
		severity = logging.Info
		break
	case Warning:
		severity = logging.Warning
		break
	case Critical:
		severity = logging.Critical
		break
	case Emergency:
		severity = logging.Emergency
		break
	case Debug:
		severity = logging.Debug
		break
	default:
		err := fmt.Errorf("no severity equavalent for google logging : (%d)", logType)
		display(err, false)
	}

	return severity
}

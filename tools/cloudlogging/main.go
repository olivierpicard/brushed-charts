package cloudlogging

// This tool transmit error with an universal single struct to
// - Google Logging
// - Google ErrorReporting (if severity is critical or emergency)
// Hence all error follow the same format accross all services
import (
	"fmt"
	"log"
	"os"
	"runtime/debug"
)

// Variables set accross the package to avoid duplicate inforamtion
// and to ease the log writing
var (
	projectID   string
	serviceName string
)

// Init MUST be called before all other functions of this package.
// It allow the initialisation of some internal variables to ease the
// the writing of reports
func Init(_projectID, _serviceName string) {
	projectID = _projectID
	serviceName = _serviceName
}

// EntryFromError create a LogEntry from an given error
func EntryFromError(err error) LogEntry {
	return LogEntry{
		Error: err,
	}
}

// ReportCritical send a log (report) to Google Logging
// and also to Google ErrorReporting with a critical severity
func ReportCritical(entry LogEntry) error {
	entry.Severity = Critical
	return report(entry)
}

// ReportEmergency send a log (report) to Google Logging
// and also to Google ErrorReporting with an emergency severity
func ReportEmergency(entry LogEntry) error {
	entry.Severity = Emergency
	return report(entry)
}

// ReportDebug send a log (report) to Google Logging
// with an debug severity
func ReportDebug(entry LogEntry) error {
	entry.Severity = Debug
	return report(entry)
}

// ReportWarning send a log (report) to Google Logging
// with an warning severity
func ReportWarning(entry LogEntry) error {
	entry.Severity = Warning
	return report(entry)
}

// ReportInfo send a log (report) to Google Logging
// with an info severity
func ReportInfo(entry LogEntry) error {
	entry.Severity = Info
	return report(entry)
}

// display the given error if `isQuiet` is false
func display(err error, isQuiet bool) {
	if isQuiet {
		return
	}
	log.Printf("%v\n", err)
	log.Println(string(debug.Stack()))
}

// report : dispatch the entry between google logging and
// google errorReporting. Only Critical and Emergency messages
// will be transmitted to Google ErrorReporting. And only non Critical
// messages will be sent to Google Logging
func report(entry LogEntry) error {
	env := os.Getenv("BRUSHED-CHARTS-ENVIRONMENT")
	if env == "test" || env == "dev" {
		return nil
	}

	if serviceName == "" || projectID == "" {
		err := fmt.Errorf("cloudlogging has not been initialized")
		println(err)
		return err
	}

	display(entry.Error, entry.IsQuiet)

	err := googleErrorReporting(entry)
	if err != nil {
		display(err, entry.IsQuiet)
		return err
	}

	err = googleLogging(entry)
	if err != nil {
		display(err, entry.IsQuiet)
		return err
	}
	return nil
}

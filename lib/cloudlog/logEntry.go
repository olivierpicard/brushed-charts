package cloudlog

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"runtime/debug"
	"strings"

	"cloud.google.com/go/errorreporting"
)

// LogEntry is a struct uses to transmit precise
// information about the error.
type LogEntry struct {
	Error error
	Stack []byte
}

func (entry *LogEntry) initFromError(err error) {
	entry.Error = err
	entry.Stack = makeStackTrace(err)
}

func (entry *LogEntry) printIfAllowed() {
	if os.Getenv(envKeyNoPrint) == "true" {
		return
	}

	log.Printf("%v\n%s", entry.Error, entry.Stack)
}

func (entry *LogEntry) toGoogleErrorReportEntry() errorreporting.Entry {
	var googleEntry errorreporting.Entry
	googleEntry.Error = entry.Error
	googleEntry.Stack = entry.Stack
	return googleEntry
}

func makeStackTrace(err error) []byte {
	if !isErrorContainsStack(err) {
		return debug.Stack()
	}
	stack := extractStackFromError(err)
	return convertStringToBytes(stack)
}

func isErrorContainsStack(err error) bool {
	messageWithStackTrace := extractStackFromError(err)
	if messageWithStackTrace == "" {
		return false
	}
	return true
}

func extractStackFromError(err error) string {
	errorMessage := getErrorMessage(err)
	errorWithStack := getFullError(err)
	stack := strings.TrimPrefix(errorWithStack, errorMessage)
	stack = strings.TrimPrefix(stack, "\n")

	return stack
}

func getFullError(err error) string {
	return fmt.Sprintf("%+v", err)
}

func getErrorMessage(err error) string {
	return fmt.Sprintf("%v", err)
}

func convertStringToBytes(message string) []byte {
	buffer := bytes.NewBufferString(message)
	return buffer.Bytes()
}

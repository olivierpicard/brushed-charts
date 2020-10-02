package testutil

import (
	"io/ioutil"
	"log"
	"os"
	"strings"
)

// ExcuteFunctionToCaptureLog will capture the output (log) of
// the given function `f` and return the result as a string
// Example : ExcuteFunctionToCaptureLog(func(){ logToCapture() })
func ExcuteFunctionToCaptureLog(f func()) string {
	reader, writer := openLogCapture()
	f()
	closeLogCapture(writer)
	logCaptured := readLogCapture(reader)
	logCaptured = removeDatetimeFromLog(logCaptured)
	logCaptured = strings.TrimSuffix(logCaptured, "\n")
	return logCaptured
}

func openLogCapture() (*os.File, *os.File) {
	reader, writer, err := os.Pipe()
	if err != nil {
		panic("Can't create a pipe to capture logs")
	}
	log.SetOutput(writer)
	return reader, writer
}

func closeLogCapture(writer *os.File) {
	writer.Close()
}

func readLogCapture(reader *os.File) string {
	bytes, _ := ioutil.ReadAll(reader)
	return string(bytes)
}

func removeDatetimeFromLog(logCapture string) string {
	if len(logCapture) <= 20 {
		return logCapture
	}
	return logCapture[20:]
}

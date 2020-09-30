package cloudlog

import (
	"io/ioutil"
	"log"
	"os"
)

func excuteFunctionToCaptureLog(f func()) string {
	reader, writer := openLogCapture()
	f()
	closeLogCapture(writer)
	logCaptured := readLogCapture(reader)
	logCaptured = removeDatetimeFromLog(logCaptured)
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

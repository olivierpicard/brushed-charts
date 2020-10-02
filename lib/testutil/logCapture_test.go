package testutil

import (
	"log"
	"testing"

	"github.com/tj/assert"
)

func Test_ExcuteFunctionToCaptureLog(t *testing.T) {
	logMessage := "a log that will be captured (I hope)"
	functionThatPrintAMessage := func() {
		log.Print(logMessage)
	}

	capturedLog := ExcuteFunctionToCaptureLog(functionThatPrintAMessage)
	assert.Equal(t, logMessage, capturedLog)
}

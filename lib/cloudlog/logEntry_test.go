package cloudlog

import (
	"bytes"
	"fmt"
	"log"
	"testing"

	"github.com/pkg/errors"
	"github.com/tj/assert"
)

func Test_ConvertStringToBytes_Right(t *testing.T) {
	message := "to bytes"
	messageToBytes := bytes.NewBufferString(message).Bytes()
	assert.Equal(t, messageToBytes, convertStringToBytes(message))
}

func Test_isErrorWithStackWrapped(t *testing.T) {
	noStackError := fmt.Errorf("basic error with no stack")
	stackError := errors.New("error with embedded stack trace")

	assert.False(t, isErrorContainsStack(noStackError))
	assert.True(t, isErrorContainsStack(stackError))
}

func Test_getFullError_ErrorWithStack(t *testing.T) {
	message := "an error"
	err := errors.New(message)
	errorWithStack := getFullError(err)

	assert.NotEmpty(t, errorWithStack)
	assert.Contains(t, errorWithStack, message)
	assert.Contains(t, errorWithStack, "_test.go:")
}
func Test_extractStackFromError_ErrorWithStack(t *testing.T) {
	message := "An error"
	err := errors.New(message)

	extractedStack := extractStackFromError(err)

	assert.NotEmpty(t, extractedStack)
	assert.NotContains(t, extractedStack, message)
	assert.Contains(t, extractedStack, "Test_extractStackFromError")
	assert.Contains(t, extractedStack, "_test.go")
}

func Test_extractStackFromError_ErrorWithoutStack(t *testing.T) {
	message := "An error"
	err := fmt.Errorf(message)
	extractedStack := extractStackFromError(err)
	assert.Empty(t, extractedStack)
}

func Test_LogEntry_initFromError_DefaultError(t *testing.T) {
	var entry LogEntry
	errorMessage := "crash test"
	err := fmt.Errorf(errorMessage)

	entry.initFromError(err)
	assert.EqualError(t, entry.Error, errorMessage)
}

func Test_LogEntry_initFromError_StackWrapped(t *testing.T) {
	var entry LogEntry
	errorMessage := "crash test"
	err := errors.New(errorMessage)

	entry.initFromError(err)
	assert.EqualError(t, entry.Error, errorMessage)

	fullStackError := fmt.Sprintf("%+v", err)
	assert.Contains(t, fullStackError, string(entry.Stack))
	assert.NotContains(t, string(entry.Stack), errorMessage)
}

func Test_LogEntry_Print(t *testing.T) {
	var entry LogEntry

	err := errors.New("Random error")
	entry.initFromError(err)
	logExpected := excuteFunctionToCaptureLog(func() { log.Printf("%v\n%s", entry.Error, entry.Stack) })
	logCaptured := excuteFunctionToCaptureLog(func() { entry.print() })
	assert.Equal(t, logExpected, logCaptured)
}

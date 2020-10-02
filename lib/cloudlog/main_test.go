package cloudlog

import (
	"fmt"
	"os"
	"testing"

	"github.com/pkg/errors"
	"github.com/tj/assert"
)

var errTest = fmt.Errorf("A report test")

const (
	testProjectID   = "test-proj.12"
	testServiceName = "cloudlog_test"
	testEnvironment = "dev"
)

func init() {
	os.Setenv(envKeyProjectID, testProjectID)
	os.Setenv(envKeyServiceName, testServiceName)
	os.Setenv(envKeyEnvironment, testEnvironment)
}

func Test_Critical_Log(t *testing.T) {
	err := errors.New("An error")
	logCaptured := excuteFunctionToCaptureLog(func() { Critical(err) })
	stack := fmt.Sprintf("%+v", err)
	assert.Contains(t, logCaptured, err.Error())
	assert.Contains(t, logCaptured, stack)
}

func Test_Critical_NoProjectID_Log(t *testing.T) {
	os.Setenv(envKeyProjectID, "")
	Test_Critical_Log(t)
}

func Test_Critical_NoProjectID_ErrorReturn(t *testing.T) {
	os.Setenv(envKeyProjectID, "")
	fakeError := errors.New("An error")
	err := Critical(fakeError)
	assert.NotNil(t, err)
}

func Test_Critical_NoServiceName_ErrorReturn(t *testing.T) {
	os.Setenv(envKeyServiceName, "")
	fakeError := errors.New("An error")
	err := Critical(fakeError)
	assert.NotNil(t, err)
}

func Test_CriticalWithMessage_Log(t *testing.T) {
	err := errors.New("An error")
	message := "This is a message"

	logExpected := fmt.Sprintf("%v\n%v", message, err)
	logCaptured := excuteFunctionToCaptureLog(
		func() { CriticalWithMessage(err, message) },
	)

	assert.Contains(t, logCaptured, logExpected)
}

func Test_Panic_Log(t *testing.T) {
	defer func() { recover() }()
	err := errors.New("An error")
	logCaptured := excuteFunctionToCaptureLog(func() { Panic(err) })
	stack := fmt.Sprintf("%+v", err)
	assert.Contains(t, logCaptured, err.Error())
	assert.Contains(t, logCaptured, stack)
}

func Test_Panic_WillPanic(t *testing.T) {
	err := errors.New("An error")
	assert.Panics(t, func() { Panic(err) })
}

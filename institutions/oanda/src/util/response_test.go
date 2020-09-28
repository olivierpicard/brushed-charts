package util

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/tj/assert"
)

func TestExtractResponseError_OK(t *testing.T) {
	resp := makeResponse(http.StatusOK, "")
	message := TryReadingResponseError(resp)
	assert.Empty(t, message)
}

func TestExtractResponseError_NoBodyNotFound(t *testing.T) {
	resp := makeResponse(http.StatusNotFound, "")
	message := TryReadingResponseError(resp)
	assert.Empty(t, message)
}

func TestExtractResponseError_InternalWithBody(t *testing.T) {
	expected := "This is an error"
	resp := makeResponse(http.StatusInternalServerError, expected)
	message := TryReadingResponseError(resp)
	assert.Equal(t, expected, message)
}

func makeResponse(statusCode int, body string) *http.Response {
	return &http.Response{
		Status:     http.StatusText(statusCode),
		StatusCode: statusCode,
		Body:       ioutil.NopCloser(bytes.NewBufferString(body)),
	}
}

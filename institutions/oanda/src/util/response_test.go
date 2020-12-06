package util

import (
	"net/http"
	"testing"

	"github.com/tj/assert"
)

func TestExtractResponseBody_StatusOK_WithEmptyBody(t *testing.T) {
	parametrableTestExtractResponseBody(t, "", http.StatusOK)
	parametrableTestExtractResponseBody(t, "", http.StatusNotFound)
	parametrableTestExtractResponseBody(t, "this is a body", http.StatusNotFound)
}

func parametrableTestExtractResponseBody(t *testing.T, body string, statusCode int) {
	resp := MakeResponse(http.StatusOK, body)
	extractedBody := TryReadingResponseBody(resp)
	assert.Equal(t, body, extractedBody)
}

func Test_IsHTTPResponseError(t *testing.T) {
	parametrableTestIsHTTPResponseError(t, MakeResponse(http.StatusOK, ""), false)
	parametrableTestIsHTTPResponseError(t, MakeResponse(http.StatusAccepted, "a body"), false)
	parametrableTestIsHTTPResponseError(t, MakeResponse(http.StatusBadGateway, ""), true)
	parametrableTestIsHTTPResponseError(t, MakeResponse(http.StatusInternalServerError, "a body"), true)
	parametrableTestIsHTTPResponseError(t, MakeResponse(http.StatusNotFound, ""), true)

}

func parametrableTestIsHTTPResponseError(t *testing.T, resp *http.Response, expected bool) {
	isAnError := IsHTTPResponseError(resp)
	assert.Equal(t, expected, isAnError)
}

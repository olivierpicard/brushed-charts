package util

import (
	"bytes"
	"io/ioutil"
	"net/http"
)

// TryReadingResponseBody try to read the body of the given response
// If body is empty or there is an issue during the reading
// an empty string is returned
func TryReadingResponseBody(resp *http.Response) string {
	if resp == nil || resp.Body == nil {
		return ""
	}

	bytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return ""
	}

	body := string(bytes)
	return body
}

// IsHTTPResponseError return true if the status code
// of the given `response` is not in the range 2xx.
// Else it return false
func IsHTTPResponseError(resp *http.Response) bool {
	if resp == nil {
		return true
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return true
	}
	return false
}

// MakeResponse create a response based on the given `statusCode`
// `body`. This function is useful for testing purpose
func MakeResponse(statusCode int, body string) *http.Response {
	return &http.Response{
		Status:     http.StatusText(statusCode),
		StatusCode: statusCode,
		Body:       ioutil.NopCloser(bytes.NewBufferString(body)),
	}
}

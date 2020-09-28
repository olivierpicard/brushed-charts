package util

import (
	"io/ioutil"
	"net/http"
)

// TryReadingResponseError try to read the body of the given response
// to give an error message as string. If body is empty an empty string
// is returned
func TryReadingResponseError(resp *http.Response) string {
	if resp.StatusCode == 200 {
		return ""
	}

	bytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return ""
	}

	body := string(bytes)
	return body
}

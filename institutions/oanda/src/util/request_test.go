package util

import (
	"net/http"
	"testing"

	"github.com/tj/assert"
)

func TestMakeBearerGetRequest(t *testing.T) {
	const token = "1234B12X"
	const url = "oanda.api/v3/accounts"

	req, err := MakeBearerGetRequest(url, token)
	assert.Nil(t, err)

	validateURLFromRequest(t, req, url)
	validateHeaderFromRequest(t, req.Header, token)
}

func validateURLFromRequest(t *testing.T, req *http.Request, url string) {
	urlFromRequest := req.URL.String()
	assert.EqualValues(t, urlFromRequest, url)
}

func validateHeaderFromRequest(t *testing.T, header http.Header, token string) {
	expected := "application/json"
	assert.Equal(t, expected, header.Get("Content-Type"))

	expected = "Bearer " + token
	assert.Equal(t, expected, header.Get("Authorization"))
}

func Test_MakeBearerGetRequest_EmptyTokenAndUrl(t *testing.T) {
	const token = ""
	const url = ""

	_, err := MakeBearerGetRequest(url, token)
	assert.NotNil(t, err)
}

func Test_MakeBearerGetRequest_EmptyToken(t *testing.T) {
	const token = ""
	const url = "oanda.api/v3/accounts"

	_, err := MakeBearerGetRequest(url, token)
	assert.NotNil(t, err)
}

func Test_MakeBearerGetRequest_EmptyUrl(t *testing.T) {
	const token = "1234"
	const url = ""

	_, err := MakeBearerGetRequest(url, token)
	assert.NotNil(t, err)
}

package util

import (
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/tj/assert"
)

func Test_MockServerHTTP2(t *testing.T) {
	expectedBody := "a body"
	statusCode := http.StatusOK
	mockServer := CreateMockServerHTTP2(statusCode, expectedBody)
	defer mockServer.Close()

	request, err := http.NewRequest("GET", mockServer.URL, nil)
	assert.Nil(t, err)

	response, err := mockServer.Client().Do(request)
	assert.Nil(t, err)
	assert.Equal(t, statusCode, response.StatusCode)

	bytes, err := ioutil.ReadAll(response.Body)
	assert.Nil(t, err)

	actualBody := string(bytes)
	assert.NotEmpty(t, response.Body)
	assert.Equal(t, expectedBody, actualBody)
}

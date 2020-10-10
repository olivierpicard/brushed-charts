package candle

import (
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/pkg/errors"
	"github.com/tj/assert"
)

const (
	mockDirPath = "/etc/brushed-charts/mock/"
)

func Test_Stream(t *testing.T) {
	statusCode := http.StatusOK
	responseBody, err := readStreamMockFile("streamCandles.json")
	assert.Nil(t, err)

	mockServer := util.CreateMockServerHTTP2(statusCode, responseBody)
	mockInput := mockInputEntry(mockServer.URL)

	stream, err := Stream(mockServer.Client(), mockInput)
	assert.Nil(t, err)
	select {
	case resp := <-stream.Stream:
		assert.NotEmpty(t, resp)
		assert.Equal(t, resp.LatestCandles[0].Instrument, "EUR_USD")
		assert.Equal(t, resp.LatestCandles[1].Granularity, "M1")
	case e := <-stream.Err:
		assert.FailNow(t, e.Error())
	case e := <-stream.Fatal:
		assert.FailNow(t, e.Error())
	}
}

func Test_Stream_MissingJSONField(t *testing.T) {
	statusCode := http.StatusOK
	responseBody, err := readStreamMockFile("streamCandles_without_Instrument.json")
	assert.Nil(t, err)

	mockServer := util.CreateMockServerHTTP2(statusCode, responseBody)
	mockInput := mockInputEntry(mockServer.URL)

	stream, err := Stream(mockServer.Client(), mockInput)
	assert.Nil(t, err)
	select {
	case <-stream.Stream:
		assert.FailNow(t, "No response was expected")
	case <-stream.Err:
		assert.FailNow(t, "No error but a fatal was expected")
	case e := <-stream.Fatal:
		assert.NotNil(t, e)
		assert.NotEmpty(t, e.Error())
	}
}

func Test_Stream_BadJSONSyntaxe(t *testing.T) {
	statusCode := http.StatusOK
	responseBody, err := readStreamMockFile("streamCandles.json")
	assert.Nil(t, err)
	bodyWithSyntaxError := responseBody[1:]

	mockServer := util.CreateMockServerHTTP2(statusCode, bodyWithSyntaxError)
	mockInput := mockInputEntry(mockServer.URL)

	stream, err := Stream(mockServer.Client(), mockInput)
	assert.Nil(t, err)
	select {
	case <-stream.Stream:
		assert.FailNow(t, "No response was expected")
	case <-stream.Err:
		assert.FailNow(t, "No error but a fatal was expected")
	case e := <-stream.Fatal:
		assert.NotNil(t, e)
		assert.NotEmpty(t, e.Error())
	}
}

func Test_Stream_HTTPErrorStatusCode(t *testing.T) {
	statusCode := http.StatusNotFound
	body := ""

	mockServer := util.CreateMockServerHTTP2(statusCode, body)
	mockInput := mockInputEntry(mockServer.URL)

	stream, err := Stream(mockServer.Client(), mockInput)
	assert.Nil(t, err)

	select {
	case <-stream.Stream:
		assert.FailNow(t, "No response was expected")
	case err := <-stream.Err:
		assert.NotNil(t, err)
		assert.NotEmpty(t, err.Error())
	case <-stream.Fatal:
		assert.FailNow(t, "No error but a fatal was expected")
	}
}

func Test_Stream_NilClient(t *testing.T) {
	mockInput := mockInputEntry("adomain")
	stream, err := Stream(nil, mockInput)

	assert.NotNil(t, err)
	assert.Contains(t, err.Error(), "Client can't be nil")
	assert.Empty(t, stream)
}

func readStreamMockFile(filename string) (string, error) {
	pathToJSONFile := mockDirPath + filename
	bytes, err := ioutil.ReadFile(pathToJSONFile)
	if err != nil {
		err = errors.New("Can't read the file (" + pathToJSONFile + ")\n" + err.Error())
		return "", err
	}

	mockStreamResponse := string(bytes)
	return mockStreamResponse, nil
}

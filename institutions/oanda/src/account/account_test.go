package account

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/tj/assert"
)

const (
	token      = "1234B12X"
	domainname = "oanda.api"
	accountURL = domainname + "/v3/accounts"
)

func Test_GetAccountID_NormalCondition(t *testing.T) {
	expectedID := "123-456-234-123"
	body := fmt.Sprintf(`{"accounts": [
		{"id":"%v"}
		]}`, expectedID)

	mockServer := createMockServer(http.StatusOK, body)
	defer mockServer.Close()
	assertNoErrorGetAccountID(t, expectedID, mockServer)
}

func createMockServer(statusCode int, body string) *httptest.Server {
	mockServer := httptest.NewUnstartedServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(statusCode)
		if body == "" {
			http.NoBody.WriteTo(w)
		}
		w.Write([]byte(body))
	}))

	mockServer.EnableHTTP2 = true
	mockServer.StartTLS()
	return mockServer
}

func assertNoErrorGetAccountID(t *testing.T, expectedID string, mockServer *httptest.Server) {
	fetchedID, err := GetAccountID(mockServer.Client(), token, mockServer.URL)
	assert.Nil(t, err)
	assert.Equal(t, expectedID, fetchedID)
}

func Test_GetAccountID_NotFound_NoBody(t *testing.T) {
	body := ""
	mockServer := createMockServer(http.StatusNotFound, body)
	defer mockServer.Close()
	assertErrorGetAccountID(t, body, mockServer)
}

func assertErrorGetAccountID(t *testing.T, errorMessage string, mockServer *httptest.Server) {
	fetchedID, err := GetAccountID(mockServer.Client(), token, mockServer.URL)
	assert.NotNil(t, err)
	assert.Contains(t, err.Error(), errorMessage)

	if !strings.Contains(err.Error(), "Error when fetching accountID") &&
		!strings.Contains(err.Error(), "Error during JSON parsing") {
		assert.FailNow(t, "returned error does not contain default error message : \n"+err.Error())
	}

	assert.Empty(t, fetchedID)
}

func Test_GetAccountID_InternalServerError_WithMessage(t *testing.T) {
	body := "This is a message"
	mockServer := createMockServer(http.StatusInternalServerError, body)
	defer mockServer.Close()
	assertErrorGetAccountID(t, body, mockServer)
}

func Test_GetAccountID_Accepted_NoBody(t *testing.T) {
	body := ""
	mockServer := createMockServer(http.StatusAccepted, body)
	defer mockServer.Close()
	assertErrorGetAccountID(t, body, mockServer)
}

func Test_GetAccountID_OK_MultiIDs(t *testing.T) {
	expectedID := "123-456-2d34-123"
	body := fmt.Sprintf(`{"accounts": [
		{"id":"%v", "tags":["apprentice"]},
		{"id":"12000-9876d-765445", "tags":["real", "tradingView"]}
		]}`, expectedID)
	mockServer := createMockServer(http.StatusAccepted, body)
	defer mockServer.Close()
	assertNoErrorGetAccountID(t, expectedID, mockServer)
}

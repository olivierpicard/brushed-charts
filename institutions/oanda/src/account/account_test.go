package account

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"testing"

	"github.com/tj/assert"
)

const (
	token      = "1234B12X"
	domainname = "oanda.api"
	accountURL = domainname + "/v3/accounts"
)

func init() {
	os.Setenv("OANDA_API_TOKEN", token)
	os.Setenv("OANDA_API_URL", domainname)
}

func Test_GetAccountID_NormalCondition(t *testing.T) {
	expectedID := "123-456-234-123"
	body := fmt.Sprintf(`{"accounts": [
		{"id":"%v"}
		]}`, expectedID)

	mockServer := createMockServer(http.StatusOK, body)
	defer mockServer.Close()
	makeMockAccountEnvironmentURL(mockServer.URL)
	assertNoErrorGetAccountID(t, expectedID, mockServer.Client())
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

func makeMockAccountEnvironmentURL(url string) {
	os.Setenv("OANDA_API_URL", url)
	oandaAccountURLPath = ""
}

func assertNoErrorGetAccountID(t *testing.T, expectedID string, client *http.Client) {
	fetchedID, err := GetAccountID(client)
	assert.Nil(t, err)
	assert.Equal(t, expectedID, fetchedID)
}

func Test_GetAccountID_NotFound_NoBody(t *testing.T) {
	body := ""
	mockServer := createMockServer(http.StatusNotFound, body)
	defer mockServer.Close()
	makeMockAccountEnvironmentURL(mockServer.URL)
	assertErrorGetAccountID(t, body, mockServer.Client())
}

func assertErrorGetAccountID(t *testing.T, errorMessage string, client *http.Client) {
	fetchedID, err := GetAccountID(client)
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
	makeMockAccountEnvironmentURL(mockServer.URL)
	assertErrorGetAccountID(t, body, mockServer.Client())
}

func Test_GetAccountID_Accepted_NoBody(t *testing.T) {
	body := ""
	mockServer := createMockServer(http.StatusAccepted, body)
	defer mockServer.Close()
	makeMockAccountEnvironmentURL(mockServer.URL)
	assertErrorGetAccountID(t, body, mockServer.Client())
}

func Test_GetAccountID_OK_MultiIDs(t *testing.T) {
	expectedID := "123-456-2d34-123"
	body := fmt.Sprintf(`{"accounts": [
		{"id":"%v", "tags":["apprentice"]},
		{"id":"12000-9876d-765445", "tags":["real", "tradingView"]}
		]}`, expectedID)
	mockServer := createMockServer(http.StatusAccepted, body)
	defer mockServer.Close()
	makeMockAccountEnvironmentURL(mockServer.URL)
	assertNoErrorGetAccountID(t, expectedID, mockServer.Client())
}

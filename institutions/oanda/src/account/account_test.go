package env

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/tj/assert"
)

const (
	token      = "1234B12X"
	domainname = "oanda.api"
	accountURL = domainname + "/v3/accounts"
)

type mockClient struct {
	statusCode int
	body       string
	response   *http.Response
	err        error
}

func (client *mockClient) Do(req *http.Request) (*http.Response, error) {
	return client.response, nil
}

func (client *mockClient) makeResponse() {
	response := util.MakeResponse(client.statusCode, client.body)
	client.response = response

}

func init() {
	os.Setenv("OANDA_API_TOKEN", token)
	os.Setenv("OANDA_API_URL", domainname)
}

func Test_GetAccountID(t *testing.T) {
	expectedID := "123-456-234-123"
	ts := httptest.NewUnstartedServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, `{"accounts": [
			{"id":"%v"}
			]}`, expectedID)
	}))
	ts.EnableHTTP2 = true
	ts.StartTLS()
	defer ts.Close()
	os.Setenv("OANDA_API_URL", ts.URL)
	oandaAccountSuffixURL = ""
	_, err := GetAccountID(ts.Client())
	assert.Nil(t, err)
}

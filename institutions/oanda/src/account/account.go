package env

import (
	"encoding/json"
	"net/http"
	"os"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
	"github.com/pkg/errors"
)

var (
	oandaAccountSuffixURL = "/v3/accounts"
)

type account struct {
	ID string `json:"id"`
}
type accountList struct {
	Accounts []account `json:"accounts"`
}

// GetAccountID retrieve one ID in the IDs returned by
// oanda servers
func GetAccountID(client *http.Client) (string, error) {
	request, err := makeAccountIDRequest()
	if err != nil {
		return "", err
	}

	response, err := sendRequest(client, request)
	if err != nil {
		return "", err
	}
	defer response.Body.Close()

	accounts, err := getAccountListFromBody(response)
	if err != nil {
		return "", err
	}

	firstAccountID := accounts[0].ID

	return firstAccountID, nil
}

func makeAccountIDRequest() (*http.Request, error) {
	token := os.Getenv("OANDA_API_TOKEN")
	url := os.Getenv("OANDA_API_URL") + oandaAccountSuffixURL
	req, err := util.MakeBearerGetRequest(url, token)
	return req, err
}

func sendRequest(client *http.Client, request *http.Request) (*http.Response, error) {
	response, err := client.Do(request)
	if err != nil {
		body := util.TryReadingResponseBody(response)
		if util.IsHTTPResponseError(response) {
			err := errors.New("Error when fetching accountID from oanda\n" + body)
			return nil, err
		}
	}

	return response, nil
}

func getAccountListFromBody(response *http.Response) ([]account, error) {
	var accList accountList
	if response == nil {
		return []account{}, nil
	}
	err := json.NewDecoder(response.Body).Decode(&accList)
	if err != nil {
		return []account{}, errors.New("Error during JSON parsing\n" + err.Error())
	}
	return accList.Accounts, nil
}

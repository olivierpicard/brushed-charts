package env

import (
	"net/http"
	"os"

	"github.com/brushed-charts/backend/institutions/oanda/src/util"
)

type account struct {
	ID string `json:"id"`
}
type accountList struct {
	Accounts []account `json:"accounts"`
}

// GetAccountID retrieve one ID in the IDs returned by
// oanda servers
func GetAccountID(client *http.Client) string {
	req, _ := makeAccountIDRequest()
	client.Do(req)
	return ""
}

func makeAccountIDRequest() (*http.Request, error) {
	token := os.Getenv("OANDA_API_TOKEN")
	url := os.Getenv("OANDA_API_URL") + "/v3/accounts"
	req, err := util.MakeBearerGetRequest(url, token)
	return req, err
}

/*
func all() {

	clog.Init(projectID, serviceName)

	if resp.StatusCode != 200 {

	}
	defer resp.Body.Close()

	var acclist AccountList
	err = json.NewDecoder(resp.Body).Decode(&acclist)
	if err != nil {
		m := fmt.Errorf("Error when decoding json \n%v", err)
		clog.ReportCritical(clog.EntryFromError(m))
		return "", err
	}

	id := acclist.Accounts[0].ID
	return id, nil
}
*/

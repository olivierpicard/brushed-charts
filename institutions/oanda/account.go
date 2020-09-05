package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	clog "github.com/brushed-charts/backend/tools/cloudlogging"
)

func getAccountID() (string, error) {
	type Account struct {
		ID string `json:"id"`
	}
	type AccountList struct {
		Accounts []Account `json:"accounts"`
	}

	clog.Init(projectID, serviceName)
	token := os.Getenv("OANDA_API_TOKEN")
	url := os.Getenv("OANDA_API_URL") + "/v3/accounts"
	client := http.Client{}

	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+token)

	resp, err := client.Do(req)
	if err != nil {
		clog.ReportCritical(clog.EntryFromError(err))
		return "", err
	}
	if resp.StatusCode != 200 {
		bytes, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			m := fmt.Errorf("Can't read the body of http bad response %v", err)
			clog.ReportCritical(clog.EntryFromError(m))
			return "", err
		}

		body := string(bytes)
		err = fmt.Errorf(body)
		clog.ReportCritical(clog.EntryFromError(err))
		return "", err
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

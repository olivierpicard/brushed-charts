package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/brushed-charts/backend/tools/cloudlogging"
)

func getAccountID() (string, error) {
	type Account struct {
		ID string `json:"id"`
	}
	type AccountList struct {
		Accounts []Account `json:"accounts"`
	}

	cloudlogging.Init(projectID, serviceName)
	token := os.Getenv("OANDA_API_TOKEN")
	client := http.Client{}

	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+token)

	resp, err := client.Do(req)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
		return "", err
	}
	if resp.StatusCode != 200 {
		bytes, err := ioutil.ReadAll(resp.Body)
		body := string(bytes)

		if err != nil {
			m := fmt.Errorf("Can't read the body of http bad response %v", err)
			cloudlogging.ReportCritical(cloudlogging.EntryFromError(m))
			return "", err
		}
		err = fmt.Errorf(body)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
	}
	defer resp.Body.Close()

	var acclist AccountList
	err = json.NewDecoder(resp.Body).Decode(&acclist)
	if err != nil {
		m := fmt.Errorf("Error when decoding json \n%v", err)
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(m))
		return "", err
	}

	id := acclist.Accounts[0].ID
	return id, nil
}

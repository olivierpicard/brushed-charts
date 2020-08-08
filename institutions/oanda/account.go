package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func getAccountID() string {
	type Account struct {
		ID string `json:"id"`
	}
	type AccountList struct {
		Accounts []Account `json:"accounts"`
	}

	token := os.Getenv("OANDA_API_TOKEN")
	client := http.Client{}

	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+token)

	resp, err := client.Do(req)
	if err != nil {
		reportError(err)
		log.Fatalf("Can't get the account ID \n%v", err)
	}
	if resp.StatusCode != 200 {
		bytes, err := ioutil.ReadAll(resp.Body)
		body := string(bytes)

		if err != nil {
			reportError(err)
			log.Fatalf("Can't read the body of http response %v", err)
		}
		err = fmt.Errorf(body)
		reportError(err)
		log.Fatalln(err)
	}
	defer resp.Body.Close()

	var acclist AccountList
	err = json.NewDecoder(resp.Body).Decode(&acclist)
	if err != nil {
		reportError(err)
		log.Fatalf("Error when decoding json \n%v", err)
	}

	id := acclist.Accounts[0].ID
	return id
}

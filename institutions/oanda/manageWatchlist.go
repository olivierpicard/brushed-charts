package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"regexp"
	"time"
)

func parseWatchlist() []string {
	bytes, err := ioutil.ReadFile("watchlist.txt")
	if err != nil {
		err := fmt.Errorf("Can't read the Watchlist")
		log.Fatalf("%v", err)
	}

	re := regexp.MustCompile(`(?mi)^[[:word:]]+`)
	data := string(bytes)

	return re.FindAllString(data, -1)
}

func watchlistRefreshLoop(rate string, watchlist *[]string) {
	for {
		*watchlist = parseWatchlist()
		fmt.Printf("%v\n\n", *watchlist)
		duration, _ := time.ParseDuration(rate)
		time.Sleep(duration)
	}
}

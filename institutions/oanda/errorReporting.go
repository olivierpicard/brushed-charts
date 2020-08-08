package main

import (
	"context"
	"log"

	"cloud.google.com/go/errorreporting"
)

// Send data to Google ErrorReporting
func reportError(logerr error) error {
	ctx := context.Background()
	errorClient, err := errorreporting.NewClient(ctx, projectID, errorreporting.Config{
		ServiceName: serviceName,
		OnError: func(err error) {
			log.Printf("Could not log error to ErrorReporting: \n%v", err)
		},
	})
	if err != nil {
		log.Printf("%v", err)
		return err
	}
	defer errorClient.Close()

	errorClient.Report(errorreporting.Entry{
		Error: logerr,
	})
	return nil
}

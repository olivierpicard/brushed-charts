package main

import (
	"context"
	"fmt"

	"cloud.google.com/go/errorreporting"
)

// Send data to Google ErrorReporting
func googleErrorReporting(entry LogEntry) error {
	if entry.Severity != Critical && entry.Severity != Emergency {
		return nil
	}

	ctx := context.Background()

	errorClient, err := errorreporting.NewClient(ctx, projectID, errorreporting.Config{
		ServiceName: serviceName,
		OnError: func(err error) {
			m := fmt.Errorf("API GCloud -- Could not log error to ErrorReporting: \n%v", err)
			display(m, entry.IsQuiet)
		},
	})
	if err != nil {
		return err
	}
	defer errorClient.Close()

	remoteEntry := errorreporting.Entry{
		Error: entry.Error,
	}
	if len(entry.Stack) != 0 {
		remoteEntry.Stack = entry.Stack
	}
	errorClient.Report(remoteEntry)
	return nil
}

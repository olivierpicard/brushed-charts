package main

import (
	"context"
	"runtime/debug"

	"cloud.google.com/go/logging"
)

// Send data to Google Cloud Logging
func googleLogging(entry LogEntry) error {
	ctx := context.Background()
	// Creates a client.
	client, err := logging.NewClient(ctx, projectID)
	if err != nil {
		return err
	}
	defer client.Close()

	if len(entry.Stack) == 0 {
		entry.Stack = debug.Stack()
	}

	severity := entry.Severity.toGoogleSeverity()
	logger := client.Logger(serviceName).StandardLogger(severity)
	gloggingEntry := errorSpec{
		ErrorString: entry.Error.Error(),
		ServiceName: serviceName,
		Message:     entry.Message,
		Stack:       string(entry.Stack),
	}

	logger.Printf("%#v", gloggingEntry)
	return nil
}

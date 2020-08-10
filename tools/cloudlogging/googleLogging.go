package cloudlogging

import (
	"context"
	"log"
	"runtime/debug"

	"cloud.google.com/go/logging"
)

// Send data to Google Cloud Logging
func googleLogging(entry LogEntry) error {
	if entry.Severity == Critical {
		return nil
	}
	ctx := context.Background()
	// Creates a client.
	client, err := logging.NewClient(ctx, projectID)
	if err != nil {
		log.Printf("googleLogging error - %v", err)
		return err
	}
	defer client.Close()

	if len(entry.Stack) == 0 {
		entry.Stack = debug.Stack()
	}

	severity := entry.Severity.toGoogleSeverity()
	logger := client.Logger(serviceName)

	var labels = map[string]string{
		"error":       entry.Error.Error(),
		"serviceName": serviceName,
		"stack":       string(entry.Stack),
	}
	if entry.Message != "" {
		labels["message"] = entry.Message
	}

	logger.Log(logging.Entry{
		Payload:  labels,
		Severity: severity,
	})

	return nil
}

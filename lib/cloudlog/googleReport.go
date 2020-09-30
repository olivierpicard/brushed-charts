package cloudlog

import (
	"context"
	"fmt"
	"os"

	"cloud.google.com/go/errorreporting"
)

// Send data to Google ErrorReporting
func googleErrorReporting(entry LogEntry) error {
	client, err := initGoogleErrorReportClient()
	if err != nil {
		return err
	}
	defer client.Close()

	googleEntry := entry.toGoogleErrorReportEntry()
	if !isInDevelopmentEnvironment() {
		client.Report(googleEntry)
	}

	return nil
}

func initGoogleErrorReportClient() (*errorreporting.Client, error) {
	ctx := context.Background()
	errorClient, err := errorreporting.NewClient(ctx, projectID, errorreporting.Config{
		ServiceName: serviceName,
		OnError:     onGoogleErrorReportingFail,
	})
	return errorClient, err
}

func onGoogleErrorReportingFail(err error) {
	var entryForGoogleError LogEntry
	customError := fmt.Errorf("API GCloud -- Could not log error to ErrorReporting: \n%v", err)
	entryForGoogleError.initFromError(customError)
	entryForGoogleError.print()
}

func isInDevelopmentEnvironment() bool {
	env := os.Getenv(envKeyEnvironment)
	if env == "dev" {
		return true
	}
	return false
}

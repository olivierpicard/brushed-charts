package main

import (
	"context"

	secretmanager "cloud.google.com/go/secretmanager/apiv1"
	"github.com/brushed-charts/backend/tools/cloudlogging"
	secretmanagerpb "google.golang.org/genproto/googleapis/cloud/secretmanager/v1"
)

// getToken retrieve Oanda api token from Google Secret Manager
// Env variable GOOGLE_APPLICATION_CREDENTIALS should be accessible
func getToken() string {
	const secretName = "oanda-api-token"
	const secretURL = "projects/" + projectID + "/secrets/" + secretName + "/versions/latest"
	return accessSecretVersion(secretURL)
}

func accessSecretVersion(name string) string {
	cloudlogging.Init(projectID, serviceName)

	// Create the client.
	ctx := context.Background()

	client, err := secretmanager.NewClient(ctx)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
	}

	// Build the request.
	req := &secretmanagerpb.AccessSecretVersionRequest{
		Name: name,
	}

	// Call the API.
	result, err := client.AccessSecretVersion(ctx, req)
	if err != nil {
		cloudlogging.ReportCritical(cloudlogging.EntryFromError(err))
	}

	return string(result.Payload.Data)
}

package main

import (
	"context"
	"log"

	secretmanager "cloud.google.com/go/secretmanager/apiv1"
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
	// name := "projects/my-project/secrets/my-secret/versions/5"
	// name := "projects/my-project/secrets/my-secret/versions/latest"

	// Create the client.
	ctx := context.Background()

	client, err := secretmanager.NewClient(ctx)
	if err != nil {
		reportError(err)
		log.Fatalf("failed to create secretmanager client: %v", err)
	}

	// Build the request.
	req := &secretmanagerpb.AccessSecretVersionRequest{
		Name: name,
	}

	// Call the API.
	result, err := client.AccessSecretVersion(ctx, req)
	if err != nil {
		reportError(err)
		log.Fatalf("failed to access secret version: %v", err)
	}

	return string(result.Payload.Data)
}

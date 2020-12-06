package secret

import (
	"context"
	"os"

	secretmanager "cloud.google.com/go/secretmanager/apiv1"
	"github.com/pkg/errors"
	secretmanagerpb "google.golang.org/genproto/googleapis/cloud/secretmanager/v1"
)

var (
	projectID string
)

// GetOandaAPIToken fetch the token to work with Oanda API
// stored on google secret manager
func GetOandaAPIToken(projectID string) (string, error) {
	secretName, err := getOandaAPITokenFromEnvironmentVariable("SECRET_NAME_OANDA_API_TOKEN")
	URL, err := makeURLForSecret(projectID, secretName, "latest")
	if err != nil {
		return "", err
	}

	secret, err := getSecret(URL, secretName)
	return secret, err

}

func getSecret(URL, secretName string) (string, error) {
	requestForSecret := makeRequestToGetSecret(URL)

	client, err := createClient()
	if err != nil {
		return "", err
	}

	secret, err := sendRequestForSecret(client, requestForSecret)
	if err != nil {
		return "", err
	}

	return secret, nil
}

func getOandaAPITokenFromEnvironmentVariable(name string) (string, error) {
	secretName := os.Getenv(name)
	if secretName == "" {
		return "", errors.New("Environment variables \"" + name + "\" is empty")
	}
	return secretName, nil
}

func makeURLForSecret(projectID string, secretName string, version string) (string, error) {
	if projectID == "" || secretName == "" || version == "" {
		return "", errors.New("Secret -- Can't make URL to fetch secret because some input arguments are empty")
	}
	return "projects/" + projectID + "/secrets/" + secretName + "/versions/" + version, nil
}

func createClient() (*secretmanager.Client, error) {
	ctx := context.Background()
	client, err := secretmanager.NewClient(ctx)
	if err != nil {
		return nil, err
	}
	return client, nil
}

func makeRequestToGetSecret(secretURL string) *secretmanagerpb.AccessSecretVersionRequest {
	req := &secretmanagerpb.AccessSecretVersionRequest{
		Name: secretURL,
	}
	return req
}

func sendRequestForSecret(client *secretmanager.Client, request *secretmanagerpb.AccessSecretVersionRequest) (string, error) {
	if os.Getenv("BRUSHED-CHARTS-ENVIRONMENT") == "unit-test" {
		return "", nil
	}
	ctx := context.Background()
	result, err := client.AccessSecretVersion(ctx, request)
	if err != nil {
		return "", err
	}

	return string(result.Payload.Data), nil
}

package secret

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/tj/assert"
)

func init() {
	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS",
		"/etc/brushed-charts/credentials/backend-institution_account-service.json")
	os.Setenv("BRUSHED-CHARTS-ENVIRONMENT", "unit-test")
}

func Test_makeSecretURL(t *testing.T) {
	projectID = "bc"
	secretName := "key"
	version := "latest"
	expectedURL := fmt.Sprintf(
		"projects/%s/secrets/%s/versions/%s",
		projectID, secretName, version)
	actualURL := makeURLForSecret(projectID, secretName, version)
	assert.Equal(t, expectedURL, actualURL)
}

func Test_createClient_NoCredential(t *testing.T) {
	rescuedCredentials := os.Getenv("GOOGLE_APPLICATION_CREDENTIALS")
	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", "")
	defer os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", rescuedCredentials)

	client, err := createClient()
	assert.NotNil(t, err)
	assert.Contains(t, strings.ToLower(err.Error()), "credential")
	assert.Nil(t, client)
}

func Test_createClient_WithCredential(t *testing.T) {
	client, err := createClient()
	assert.Nil(t, err)
	assert.NotNil(t, client)
}

func Test_makeRequestToGetSecret(t *testing.T) {
	secretURL := "projects/bc/secrets/asecret/versions/latest"
	requestForSecret := makeRequestToGetSecret(secretURL)
	assert.Equal(t, secretURL, requestForSecret.Name)
}

func Test_GetOandaAPIToken(t *testing.T) {
	t.Log(os.Getenv("BRUSHED-CHARTS-ENVIRONMENT"))
	projectID := "bc"
	_, err := GetOandaAPIToken(projectID)
	assert.Nil(t, err)
}

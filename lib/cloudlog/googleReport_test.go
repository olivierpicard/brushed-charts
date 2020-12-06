package cloudlog

import (
	"os"
	"testing"

	"github.com/brushed-charts/backend/lib/testutil"
	"github.com/pkg/errors"
	"github.com/tj/assert"
)

func Test_OnGoogleErrorReportingFail(t *testing.T) {
	anError := errors.New("Random error")
	logCaptured := testutil.ExcuteFunctionToCaptureLog(func() {
		onGoogleErrorReportingFail(anError)
	})
	assert.Contains(t, logCaptured, "Could not log error to ErrorReporting")
}

func Test_InitGoogleErrorReportClient_WithCredential(t *testing.T) {
	updateGoogleCredentialPath()
	client, err := initGoogleErrorReportClient()
	assert.Nil(t, err)
	assert.NotNil(t, client)
	client.Close()
}
func Test_InitGoogleErrorReportClient_WithoutCredential_ErrorReturn(t *testing.T) {
	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", "")
	defer updateGoogleCredentialPath()

	_, err := initGoogleErrorReportClient()
	assert.NotNil(t, err)
}

func updateGoogleCredentialPath() {
	if os.Getenv("GOOGLE_APPLICATION_CREDENTIALS") != "" {
		return
	}
	os.Setenv(
		"GOOGLE_APPLICATION_CREDENTIALS",
		"/etc/brushed-charts/credentials/backend-institution_account-service.json")
}

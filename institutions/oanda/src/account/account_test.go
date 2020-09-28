package env

import (
	"os"
	"testing"
)

const (
	token      = "1234B12X"
	domainname = "oanda.api"
	accountURL = domainname + "/v3/accounts"
)

func init() {
	os.Setenv("OANDA_API_TOKEN", token)
	os.Setenv("OANDA_API_URL", domainname)
}

func TestMakeGetAccountIDRequest(t *testing.T) {
	// req, err := makeAccountIDRequest()
	// if err != nil {
	// 	testlogger.FailWithMessage(t, "Can't create this request", nil, err)
	// }
}

func TestGetAccountID() {
	// id := GetAccountID()
}

package util

import (
	"net/http"

	"github.com/pkg/errors"
)

// MakeBearerGetRequest create GET method request with the given `url`
// And add authorization `token` (Bearer) in the header. This request
// have also a `Content-Type` = "application/json"
func MakeBearerGetRequest(url, token string) (*http.Request, error) {
	err := checkBearerInputsFullness(url, token)
	if err != nil {
		return nil, err
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, errors.Wrap(err, "Can't create the bearer GET request")
	}

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+token)
	return req, nil
}

func checkBearerInputsFullness(url, token string) error {
	baseSentence := "Can't make bearer request because "

	if url == "" {
		return errors.New(baseSentence + "'url' is empty")
	}

	if token == "" {
		return errors.New(baseSentence + "'token' is empty")
	}

	return nil
}

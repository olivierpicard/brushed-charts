package util

import (
	"net/http"
	"net/http/httptest"
)

// CreateMockServerHTTP2 initialize a mock server with HTTP 2 and a TLS
// connection. Don't forget to close this server when a task is finish.
// This server can make a defined response, with a given statusCode
func CreateMockServerHTTP2(statusCode int, body string) *httptest.Server {
	mockServer := httptest.NewUnstartedServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(statusCode)
		if body == "" {
			http.NoBody.WriteTo(w)
		}
		w.Write([]byte(body))
	}))

	mockServer.EnableHTTP2 = true
	mockServer.StartTLS()
	return mockServer
}

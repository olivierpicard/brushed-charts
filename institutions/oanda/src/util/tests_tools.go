package util

import (
	"testing"

	"github.com/tj/assert"
)

// TestJSONFileEquality take two paths in input, open and compare these two files
func TestJSONFileEquality(t *testing.T, pathExpectedJSON, pathActualJSON string) {
	expectedJSONFile, err := ReadFile(pathExpectedJSON)
	assert.Nil(t, err)

	actualJSONFile, err := ReadFile(pathExpectedJSON)
	assert.Nil(t, err)

	assert.JSONEq(t, expectedJSONFile, actualJSONFile)
}

package candle

import (
	"testing"

	"github.com/tj/assert"
)

func Test_InputEntryIsValid_Empty(t *testing.T) {
	input := InputEntry{}
	err := input.containsError()
	assert.NotNil(t, err)
	assert.Contains(t, err.Error(), "is nil")
}

func Test_InputEntryIsValid_EmptyAccountID(t *testing.T) {
	input := InputEntry{
		Instruments:   []string{"A", "Value"},
		Granularities: []string{"N"},
	}
	err := input.containsError()
	assert.NotNil(t, err)
	assert.Equal(t, err.Error(), "Account ID can't be an empty")
}

func Test_InputEntryIsValid_LengthZero(t *testing.T) {
	input := InputEntry{
		Instruments:   make([]string, 0),
		Granularities: make([]string, 0),
	}

	err := input.containsError()
	assert.NotNil(t, err)
	assert.Contains(t, err.Error(), "is empty")
}

func Test_InputEntryIsValid_WithEmptyStringContent(t *testing.T) {
	input := InputEntry{
		Instruments:   []string{"Value"},
		Granularities: make([]string, 3),
	}

	err := input.containsError()
	assert.NotNil(t, err)
	assert.Equal(t, err.Error(), "Empty strings are not allowed")
}

func Test_InputEntryIsValid_Correct(t *testing.T) {
	input := InputEntry{
		Instruments:   []string{"A", "Value"},
		Granularities: []string{"N"},
		AccountID:     "12312223",
		APIDomainName: "adomain",
		APIToken:      "atoken11111",
	}
	err := input.containsError()
	assert.Nil(t, err)
}

func Test_OutputStream_Init(t *testing.T) {
	var outputStream OutputStream
	outputStream.init()
	assert.NotNil(t, outputStream.response)
	assert.NotNil(t, outputStream.err)
	assert.NotNil(t, outputStream.fatal)
}

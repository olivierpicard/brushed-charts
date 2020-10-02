package util

import (
	"os"
)

// IsInDevelopperEnvironment return true if
// the environment variable BRUSHED-CHARTS-ENVIRONMENT equal "dev"
func IsInDevelopperEnvironment() bool {
	envVarName := "BRUSHED-CHARTS-ENVIRONMENT"
	mode, _ := os.LookupEnv(envVarName)
	return mode == "dev"
}

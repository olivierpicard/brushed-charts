package util

import (
	"os"
)

// IsInDevelopmentEnvironment return true if
// the environment variable BRUSHED-CHARTS-ENVIRONMENT equal "dev"
func IsInDevelopmentEnvironment() bool {
	envVarName := "BRUSHED-CHARTS-ENVIRONMENT"
	mode, _ := os.LookupEnv(envVarName)
	return mode == "dev"
}

// // Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
// package test

// import (
// 	"log"
// 	"os"
// 	"testing"

// 	"github.com/stretchr/testify/assert"
// 	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
// )

// func TestRunBasicExample(t *testing.T) {
// 	t.Parallel()

// 	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
// 		Testing:      t,
// 		TerraformDir: "examples/basic",
// 		Prefix:       "basic",
// 		Region:       "us-south",
// 	})

// 	output, err := options.RunTestConsistency()

// 	assert.Nil(t, err, "This should not have errored")
// 	assert.NotNil(t, output, "Expected some output")
// }

// func TestRunCompleteExample(t *testing.T) {
// 	t.Parallel()

// 	usernames := []string{"admin-other"}

// 	cwd, err1 := os.Getwd()
// 	if err1 != nil {
// 		log.Fatalf("Error getting current working directory: %v", err1)
// 	}
// 	sigDirectory = cwd + "/keys"

// 	admins, err := CreateSigKeys(usernames, sigDirectory)
// 	if !assert.Nilf(t, err, "Error creating sigkeys: %v", err) {
// 		log.Fatalf("Error creating sigkeys: %v", err)
// 	}

// 	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
// 		Testing:      t,
// 		TerraformDir: "examples/complete",
// 		Prefix:       "example-hpcs",
// 		Region:       "us-south",
// 		TerraformVars: map[string]interface{}{
// 			"admins": admins,
// 		},
// 	})

// 	output, err := options.RunTestConsistency()

// 	assert.Nil(t, err, "This should not have errored")
// 	assert.NotNil(t, output, "Expected some output")
// }

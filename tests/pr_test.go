// Tests in this file are run in the PR pipeline
package test

import (
	"fmt"
	"github.com/google/uuid"
	"log"
	"os"
	"os/exec"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"

var sigDirectory string

// Note: if this is needed again in another module move the code to github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper

// CreateSigKeys generates signature keys for the provided usernames and stores them in the specified output directory.
// Each username is associated with a unique, automatically generated password. The keys are created by executing
// the 'ibmcloud tke sigkey-add' command for each username.
//
// The function first checks if the output directory exists. If it does not, it is created. If it does exist,
// all files in the directory are deleted.
//
// The resulting keys are returned as a string formatted in a way that is compatible with Terraform variable
// interpretation: as a list of maps, with each map representing an admin. Each map includes the "name", "key",
// and "token" (password) for the admin.
//
// The function will return an error if there is any problem in creating the output directory, reading its contents,
// deleting existing files, or running the 'ibmcloud tke sigkey-add' command.
//
// The output string can be directly used in Terraform variables in your test functions.
//
// Parameters:
//
//	usernames: An array of strings representing the usernames for which to generate keys.
//	outputDir: The directory in which to store the generated keys.
//
// Returns:
//
//	A string representing the generated keys in a format compatible with Terraform variables.
//	An error if any issues are encountered during execution.
func CreateSigKeys(usernames []string, outputDir string) (string, error) {
	if _, err := os.Stat(outputDir); os.IsNotExist(err) {
		err := os.Mkdir(outputDir, 0755)
		if err != nil {
			return "", err
		}
	} else {
		files, err := os.ReadDir(outputDir)
		if err != nil {
			return "", err
		}
		for _, f := range files {
			err = os.Remove(outputDir + "/" + f.Name())
			if err != nil {
				return "", err
			}
		}
	}

	adminStrings := make([]string, 0, len(usernames))

	for i, username := range usernames {
		password := uuid.New().String()

		cmd := exec.Command("ibmcloud", "tke", "sigkey-add")
		cmd.Env = append(os.Environ(), "CLOUDTKEFILES="+outputDir)
		cmd.Stdin = strings.NewReader(fmt.Sprintf("%s\n%s\n%s\n", username, password, password))
		cmdOutput, err := cmd.CombinedOutput()
		if err != nil {
			return "", fmt.Errorf("error while running 'ibmcloud tke sigkey-add': %v\nCommand output: %s", err, string(cmdOutput))
		}

		key := fmt.Sprintf("%s/%d.sigkey", outputDir, i+1)
		adminStrings = append(adminStrings, fmt.Sprintf("{ \"name\": \"%s\", \"key\": \"%s\", \"token\": \"%s\" }", username, key, password))
	}

	return fmt.Sprintf("[%s]", strings.Join(adminStrings, ", ")), nil
}

func TestMain(m *testing.M) {
	cwd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Error getting current working directory: %v", err)
	}
	sigDirectory = cwd + "/sigs"

	os.Exit(m.Run())
}

func TestRunHpcsFsCloudExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/fscloud",
		Prefix:       "hpcs",
		Region:       "us-south",
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	usernames := []string{"admin1"}

	admins, err := CreateSigKeys(usernames, sigDirectory)
	if !assert.Nilf(t, err, "Error creating sigkeys: %v", err) {
		log.Fatalf("Error creating sigkeys: %v", err)
	}

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/complete",
		Prefix:       "hpcs-crypto",
		Region:       "us-south",
		TerraformVars: map[string]interface{}{
			"admins": admins,
		},
	})

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

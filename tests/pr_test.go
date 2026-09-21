// Tests in this file are run in the PR pipeline
package test

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"testing"

	"github.com/google/uuid"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
// const resourceGroup = "geretain-test-resources"

// Note: if this is needed again in another module move the code to github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper

// CreateSigKeys generates signature keys for the provided usernames and stores them in the specified output directory.
// Each username is associated with a unique, automatically generated password. The keys are created by executing
// the 'ibmcloud tke sigkey-add' command for each username.
//
// The function first checks if the output directory exists. If it does not, it is created. If it does exist,
// all files in the directory are deleted.
//
// The resulting keys are returned as a slice of maps, where each map represents an admin with "name", "key",
// and "token" (password) fields. This type is compatible with Terraform's list(object) variable type when
// passed through testhelper's TerraformVars.
//
// The function will return an error if there is any problem in creating the output directory, reading its contents,
// deleting existing files, or running the 'ibmcloud tke sigkey-add' command.
//
// Parameters:
//
//	usernames: An array of strings representing the usernames for which to generate keys.
//	outputDir: The directory in which to store the generated keys.
//
// Returns:
//
//	A []map[string]string representing the generated keys, compatible with Terraform list(object) variables.
//	An error if any issues are encountered during execution.
func CreateSigKeys(usernames []string, outputDir string) ([]map[string]string, error) {
	if _, err := os.Stat(outputDir); os.IsNotExist(err) {
		err := os.Mkdir(outputDir, 0755)
		if err != nil {
			return nil, err
		}
	} else {
		files, err := os.ReadDir(outputDir)
		if err != nil {
			return nil, err
		}
		for _, f := range files {
			err = os.Remove(outputDir + "/" + f.Name())
			if err != nil {
				return nil, err
			}
		}
	}

	admins := make([]map[string]string, 0, len(usernames))

	for i, username := range usernames {
		password := uuid.New().String()

		cmd := exec.Command("ibmcloud", "tke", "sigkey-add")
		cmd.Env = append(os.Environ(), "CLOUDTKEFILES="+outputDir)
		cmd.Stdin = strings.NewReader(fmt.Sprintf("%s\n%s\n%s\n", username, password, password))
		cmdOutput, err := cmd.CombinedOutput()
		if err != nil {
			return nil, fmt.Errorf("error while running 'ibmcloud tke sigkey-add': %v\nCommand output: %s", err, string(cmdOutput))
		}

		key := fmt.Sprintf("%s/%d.sigkey", outputDir, i+1)
		admins = append(admins, map[string]string{
			"name":  username,
			"key":   key,
			"token": password,
		})
	}

	return admins, nil
}

func TestMain(m *testing.M) {

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

	cwd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Error getting current working directory: %v", err)
	}
	sigDirectory := cwd + "/sigs"

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

// Tests in this file are run in the PR pipeline
package test

import (
	"fmt"
	"os"
	"os/exec"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"

var admin string

func TestMain(m *testing.M) {

	mydir, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
	}
	cmd, err := exec.Command("bash", "./scripts/create_keys.sh", mydir).Output()
	if err != nil {
		fmt.Printf("error %s", err)
	}
	output := string(cmd)

	admin = output
	// fmt.Print(admin)
	os.Exit(m.Run())
}

func TestRunHpcsExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/complete",
		Prefix:       "hpcs-crypto",
		Region:       "us-south",
		TerraformVars: map[string]interface{}{
			"admins": "[" + admin + "]",
		},
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/basic",
		Prefix:       "hpcs",
		Region:       "us-south",
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	// TODO: Remove this line after the first merge to primary branch is complete to enable upgrade test
	t.Skip("Skipping upgrade test until initial code is in primary branch")

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/basic",
		Prefix:        "hpcs",
		Region:        "us-south",
		ResourceGroup: resourceGroup,
	})

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

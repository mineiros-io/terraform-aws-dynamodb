package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUnitComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-complete",
		Vars: map[string]interface{}{
			"aws_region": "us-east-1",
		},
		Upgrade: true,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)
}

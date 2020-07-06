[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# What this example shows

This example shows how to implement support for [DynamoDB Global Tables V2 (version 2019.11.21)][globalv2].

## Basic usage

The code in [main.tf] defines the following module configuration:

```hcl
module "terraform-aws-dynamodb" {
  source = "mineiros-io/dynamodb/aws"
  verion = "0.0.2"

  name         = "global"
  hash_key     = "MyKey"
  billing_mode = "PAY_PER_REQUEST"

  attributes = {
    MyKey = "S"
  }

  replica_region_names = ["eu-west-1"]
}
```

## Running the example

### Cloning the repository

```bash
git clone https://github.com/mineiros-io/terraform-aws-dynamodb.git
cd terraform-aws-dynamodb/examples/dynamodb-global-table-v2
```

### Initializing Terraform

Run `terraform init` to initialize the example and download providers and the module.

### Planning the example

Run `terraform plan` to see a plan of the changes.

### Applying the example

Run `terraform apply` to create the resources.
You will see a plan of the changes and Terraform will prompt you for approval to actually apply the changes.

### Destroying the example

Run `terraform destroy` to destroy all resources again.

<!-- References -->

[globalv2]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html

<!-- markdown-link-check-disable -->
[main.tf]: https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/examples/dynamodb-global-table-v2/main.tf
<!-- markdown-link-check-enable -->

[homepage]: https://mineiros.io/?ref=terraform-aws-dynamodb

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

terraform {
  required_version = ">= 0.12.20, < 2.0"

  required_providers {
    # replica support was added in 2.58
    aws = ">= 2.58, < 4.0"
  }
}

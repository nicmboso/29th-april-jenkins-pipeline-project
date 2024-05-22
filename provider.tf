locals {
  name = "day-team"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
provider "aws" {
  region  = "eu-west-3"
  # profile = "project1"
}

terraform {
  backend "s3" {
    bucket       = "pet-adoption-state-bucket-one"
    #use_lockfile = false
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    dynamodb_table = "pet-adoption-state-bucket-one-dynamodb-lock"
    # profile      = "project1"
  }
}

provider "vault" {
  #address = "https://vault.gaurav-devops.site"
  address = "https://vault.gatsby-devops.com"
  token   = "hvs.iFKpk6D9MRcc9RKlGjWrBoLb"
}
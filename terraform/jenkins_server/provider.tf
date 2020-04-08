provider "aws" {
    profile = "personal"
    shared_credentials_file = "~/.aws/credentials"
    region = var.region
}
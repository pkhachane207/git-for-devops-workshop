terraform {
  backend "s3" {
    bucket       = "prafull-terraform-state-handset-india"
    key          = "jenkins/prod/DR-setup/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
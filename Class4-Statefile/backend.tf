terraform {
  backend "s3" {
    bucket = "jany-bucket"
    key    = "kaizen/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "lock-statefile"
  }
}

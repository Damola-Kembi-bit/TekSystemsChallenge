terraform {
  backend "s3" {
    bucket         = "dashlabsbucket"
    region         = "us-east-1"
    key            = "Web-Server-TF/terraform.tfstate"
    encrypt        = true
  }
}

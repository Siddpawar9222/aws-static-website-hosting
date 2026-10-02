# ------------------------------------------------------------------------------
# Terraform Remote State Configuration
# ------------------------------------------------------------------------------
# Once you have run the terraform/bootstrap stack, uncomment this backend block
# and fill in your unique bucket name and DynamoDB lock table name.
#
# terraform {
#   backend "s3" {
#     bucket         = "REPLACE_WITH_YOUR_BOOTSTRAP_STATE_BUCKET_NAME"
#     key            = "prod/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-locks"
#     encrypt        = true
#   }
# }


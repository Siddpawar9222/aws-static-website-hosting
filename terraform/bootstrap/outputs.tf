output "s3_bucket_name" {
  description = "Name of the S3 bucket created for Terraform remote state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for Terraform remote state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "backend_config_snippet" {
  description = "Backend configuration snippet to paste into environments/prod/backend.tf"
  value       = <<-EOT
    bucket       = "${aws_s3_bucket.terraform_state.id}"
    key          = "prod/terraform.tfstate"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  EOT
}

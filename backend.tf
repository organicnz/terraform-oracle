# Backend Configuration (Optional)
# Uncomment and configure for remote state

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-remnawave"
#     key            = "oracle/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

# Or use OCI Object Storage
# terraform {
#   backend "http" {
#     address        = "https://objectstorage.${var.region}.oraclecloud.com/n/${var.namespace}/b/${var.bucket}/o/terraform.tfstate"
#     update_method  = "PUT"
#   }
# }

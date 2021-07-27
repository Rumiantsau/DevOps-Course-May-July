### --- === backend === --- ###

terraform {
  backend "s3" {
    bucket         = "rumiantsau-exam-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rumiantsau-exam-terraform-locks"
    encrypt        = true
  }
}

### --- === S3 for backend === --- ###

resource "aws_s3_bucket" "rumiantsau_exam_terraform_state" {
  bucket = "rumiantsau-exam-terraform-state"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }
    expiration {
      days = 90
    }

  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge ({"Name" = "rumiantsau-s3-exam"}, local.tags) 
}

### --- === Dinamo DB for backend === --- ###

resource "aws_dynamodb_table" "rumiantsau_exam_terraform_locks" {
  name         = "rumiantsau-exam-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge ({"Name" = "rumiantsau-dinamo"}, local.tags) 
}
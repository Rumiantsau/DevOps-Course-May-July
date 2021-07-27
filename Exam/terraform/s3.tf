resource "aws_s3_bucket" "rumiantsau_code_build_go" {
  bucket = "rumiantsau-code-build-go"
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
  tags = merge ({"Name" = "rumiantsau-code-build-go"}, local.tags) 
}

resource "aws_s3_bucket" "rumiantsau_code_build_python" {
  bucket = "rumiantsau-code-build-python"
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
  tags = merge ({"Name" = "rumiantsau-code-build-python"}, local.tags) 
}
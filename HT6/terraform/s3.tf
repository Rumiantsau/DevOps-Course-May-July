resource "aws_iam_role" "access_ec2_to_s3" {
  name = "access_ec2_to_s3"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = local.tags
}

resource "aws_iam_policy" "access_ec2_to_s3" {
  name        = "access_ec2_to_s3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket_for_file.bucket}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket_for_file.bucket}/*"
        }

    ]
}
EOF
}

resource "aws_iam_instance_profile" "access_ec2_to_s3" {
  name = "access_ec2_to_s3"
  role = aws_iam_role.access_ec2_to_s3.name
}

resource "aws_iam_policy_attachment" "attach_policy_to_role" {
  name       = "access_ec2_to_s3"
  roles      = [aws_iam_role.access_ec2_to_s3.name]
  policy_arn = aws_iam_policy.access_ec2_to_s3.arn
}


resource "aws_s3_bucket" "bucket_for_file" {
  bucket = "rumiantsau-bucket-for-file"
  acl    = "public-read"
  # policy = file("policy.json")
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
                  tags               = merge (
                    {"Name" = "rumiantsau-s3"}, local.tags
                          ) 
}

resource "aws_s3_bucket_policy" "bucket_for_file" {
  bucket = aws_s3_bucket.bucket_for_file.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "http custom auth secret",
    "Statement": [
        {
            "Sid": "Allow requests with my secret.",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket_for_file.bucket}/*",
            "Condition": {
                "StringLike": {
                    "aws:UserAgent": [
                        "xxxyyyzzz"
                    ]
                }
            }
        }
    ]
  })
}

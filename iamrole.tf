#iam roles 
#lambda roles

data "aws_iam_policy_document" "assumerole" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = [
      "arn:aws:s3:::marabuck/*"  # Replace with your S3 bucket name
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "LambdaIAM"  # Specify the role name
  assume_role_policy = data.aws_iam_policy_document.assumerole.json

  tags = {
    Environment = "Production"  # Example of key-value pairs for tags
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "LambdaS3Policy"
  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.s3_permissions.json
}

#----------------------------------------------------------------
#Ec2 roles
data "aws_iam_policy_document" "assumerole_ec2" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3_permissions_ec2" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [
      "arn:aws:s3:::marabuck", "arn:aws:s3:::marabuck/*" # Replace with your S3 bucket name
    ]
  }
}

resource "aws_iam_role" "ec2" {
  name               = "EC2IAM"  # Specify the role name
  assume_role_policy = data.aws_iam_policy_document.assumerole_ec2.json

  tags = {
    Environment = "Production"  # Example of key-value pairs for tags
  }
}

resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "EC2S3Policy"
  role = aws_iam_role.ec2.id

  policy = data.aws_iam_policy_document.s3_permissions_ec2.json
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2.name
}


#----------------------------------------------------------------vpc

/*data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default_subnet" {
  vpc_id = data.aws_vpc.default.id
}
*/
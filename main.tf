#keypair
resource "tls_private_key" "Keypair-test" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "keypair" {
  key_name = "marakeypair"
  public_key = tls_private_key.Keypair-test.public_key_openssh
}


//creating a new instance -------------!

resource "aws_instance" "aws_instance_created" {
  instance_type = "t2.micro"
  ami           = "ami-0d64bb532e0502c46"

  tags = {
    Name = "MaraTestInstance"
  }
  
  user_data = data.template_file.userdata-mara.rendered

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "optional"
  }

  key_name = "marakeypair"

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}

#s3 bucket
resource "aws_s3_bucket" "maras3bucket" {
    tags = {
      name = "marabuck"
    }
  bucket = "marabuck"
}

#mysql
resource "aws_instance" "aws_instance_mysql" {
  instance_type = "t2.micro"
  ami           = "ami-0d64bb532e0502c46"

  tags = {
    Name = "MaraMysql"
  }
  
  user_data = data.template_file.userdata-mysql-mara.rendered

 # subnet_id = data.aws_subnet_ids.default_subnets.ids[0]
  #private_ip = "172.31.10.10"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "optional"
  }

  key_name = "marakeypair"

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}


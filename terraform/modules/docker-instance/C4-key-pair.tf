resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {  # Correct data resource name
  key_name = var.key_pair_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.private_key.private_key_openssh
  filename = "${var.private_key_file_name}.pem"
}

data "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_object" "private_key_object" {
  bucket = data.aws_s3_bucket.s3_bucket.bucket
  key    = "${var.env}/ec2-keys/openssh_private_key.pem"
  content = tls_private_key.private_key.private_key_pem
  acl    = "private"
  content_type = "application/x-pem-file"
}
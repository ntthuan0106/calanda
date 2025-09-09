resource "aws_instance" "ec2_instance" {
  ami = var.ami_id
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  
  associate_public_ip_address = var.associate_public_ip_address
  key_name = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [var.sg_id]
  user_data = file("${path.module}/scripts/install-docker.sh")

  tags = {
    Name = var.instance_name
    env = var.env
  }
}
resource "aws_instance" "ec2" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.large"
  key_name               = var.key-name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.security-group.id]
  root_block_device {
    volume_size = 30
  }
  user_data = templatefile("./webserver-install.sh", {})

  tags = {
    Name = var.instance-name
  }
}

resource "aws_instance" "server1" {
  ami             = "ami-0fa3fe0fa7920f68e" # Amazon Linux 2023 kernel-6.1 AMI
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public1.id
  key_name        = aws_key_pair.deployer_key.key_name
  user_data       = file("server.sh")

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  tags = {
    Name = "utc-app-instance"
  }

  depends_on = [aws_security_group.webserver_sg]
}

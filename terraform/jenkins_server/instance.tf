data "aws_ami" "jenkins_server" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["linux-ami-for-jenkins-*"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.jenkins_server.image_id
  instance_type = "t2.small"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id,aws_security_group.jenkins_server.id]

  # the public SSH key
  key_name = aws_key_pair.jenkins_server.key_name

  tags = {
    Name = "Jenkins Server"
    Environment = "Dev"
  }
}


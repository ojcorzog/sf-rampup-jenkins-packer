resource "aws_key_pair" "jenkins_server" {
  key_name   = "jenkins_server_key"
  public_key = file("${path.module}/keys/jenkins_server.pub")
}
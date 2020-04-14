output "jenkins-ip" {
  value = [aws_instance.jenkins.*.public_ip]
}

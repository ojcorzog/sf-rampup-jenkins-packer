output "jenkins-ip" {
  value = [aws_instance.jenkins.*.public_ip]
}

output "aws_iam_smtp_password_v4" {
  value = aws_iam_access_key.jenkins_user.ses_smtp_password_v4
}

output "sf-rampup-repository-URL" {
  value = aws_ecr_repository.sf-rampup.repository_url
}

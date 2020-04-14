resource "aws_iam_role" "jenkins-role" {
  name               = "jenkins-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "jenkins-role" {
  name = "jenkins-role"
  role = aws_iam_role.jenkins-role.name
}

resource "aws_iam_role_policy" "admin-policy" {
  name = "jenkins-admin-role-policy"
  role = aws_iam_role.jenkins-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# group definition
resource "aws_iam_group" "jenkins" {
  name = "jenkins"
}

resource "aws_iam_policy_attachment" "jenkins-attach" {
  name       = "jenkins-attach"
  groups     = [aws_iam_group.jenkins.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_policy_attachment" "ECR-attach" {
  name       = "ECR-attach"
  groups     = [aws_iam_group.jenkins.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}


# user
resource "aws_iam_user" "jenkins_user" {
  name = "jenkins_user"
}

resource "aws_iam_access_key" "jenkins_user" {
  user = aws_iam_user.jenkins_user.name
}


resource "aws_iam_group_membership" "jenkins-users" {
  name = "jenkins-users"
  users = [
    aws_iam_user.jenkins_user.name
  ]
  group = aws_iam_group.jenkins.name
}


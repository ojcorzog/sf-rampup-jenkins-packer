# workers
resource "aws_security_group" "sf-rampup-node" {
  name        = "terraform-eks-sf-rampup-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "terraform-eks-sf-rampup-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

resource "aws_security_group_rule" "sf-rampup-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sf-rampup-node.id
  source_security_group_id = aws_security_group.sf-rampup-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "sf-rampup-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sf-rampup-node.id
  source_security_group_id = aws_security_group.sf-rampup-cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "sf-rampup-workers-ingress-workstation-https" {
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibilty in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the workers"
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.sf-rampup-node.id
  to_port           = 65535
  type              = "ingress"
}

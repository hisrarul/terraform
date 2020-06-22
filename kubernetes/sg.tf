
resource "aws_security_group" "k8s_master" {
  vpc_id      = aws_vpc.k8s_vpc.id
  name        = "k8s-master"
  description = "security group that allows all ingress and egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                    =   "k8s-master-sg"
    "kubernetes.io/cluster/k8s-israrul-demo"  =   "owned"
  }
}

# k8s worker sg

resource "aws_security_group" "k8s_worker_sg" {
  vpc_id      = aws_vpc.k8s_vpc.id
  name        = "k8s-worker-sg"
  description = "security group that allows all ingress and egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                    =   "k8s-worker-sg"
    "kubernetes.io/cluster/k8s-israrul-demo"  =   "owned"
  }
}
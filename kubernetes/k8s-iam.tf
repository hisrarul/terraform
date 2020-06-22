data "aws_iam_policy" "ssm" {
  arn           =   "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

data "aws_iam_policy" "s3" {
  arn           =   "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "k8s_master_profile" {
  name          =   format("%s-master-%s",var.name, var.iam_policy_suffix)
  role          =   aws_iam_role.k8s_master_role.name
}

resource "aws_iam_role" "k8s_master_role" {
  name          =   format("%s-%s",var.name, var.k8s_master_role_suffix)
  path          =   "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "kms" {
  name          =   format("%s-%s",var.name, var.k8s_ssm_policy_suffix)
  description   = "An IAM policy to read kms key and modify instance attribute"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "kmsReadOnly",
            "Effect": "Allow",
            "Action": [
                "kms:ListKeys",
                "kms:ListAliases",
                "kms:DescribeKey",
                "kms:Decrypt",
                "kms:Encrypt"
            ],
            "Resource": "arn:aws:kms:ap-south-1:*:key/*"
        },
        {
            "Sid": "PermissionToModifyInstanceCheck",
            "Effect": "Allow",
            "Action": [
                "ec2:ModifyInstanceAttribute"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "k8s_master_pol" {
  name          =   format("%s-%s",var.name, var.k8s_master_policy_suffix)
  description   = "An IAM policy for master"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVolumes",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyVolume",
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateRoute",
        "ec2:DeleteRoute",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteVolume",
        "ec2:DetachVolume",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:DescribeVpcs",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:AttachLoadBalancerToSubnets",
        "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateLoadBalancerPolicy",
        "elasticloadbalancing:CreateLoadBalancerListeners",
        "elasticloadbalancing:ConfigureHealthCheck",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteLoadBalancerListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DetachLoadBalancerFromSubnets",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancerPolicies",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
        "iam:CreateServiceLinkedRole",
        "kms:DescribeKey"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

# iam worker
resource "aws_iam_instance_profile" "k8s_worker_profile" {
  name          =   format("%s-worker-%s",var.name, var.iam_policy_suffix)
  role          =   aws_iam_role.k8s_worker_role.name
}

resource "aws_iam_role" "k8s_worker_role" {
  name          =   format("%s-%s",var.name, var.k8s_worker_role_suffix)
  path          =   "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "k8s_worker_pol" {
  name          =   format("%s-%s",var.name, var.k8s_worker_policy_suffix)
  description   = "An IAM policy for worker"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_worker_generic_attach" {
  role              = aws_iam_role.k8s_worker_role.name
  policy_arn        = aws_iam_policy.k8s_worker_pol.arn
}

resource "aws_iam_role_policy_attachment" "k8s_worker_s3_attach" {
  role              = aws_iam_role.k8s_worker_role.name
  policy_arn        = data.aws_iam_policy.s3.arn
}

resource "aws_iam_role_policy_attachment" "k8s_worker_ssm_attach" {
  role              = aws_iam_role.k8s_worker_role.name
  policy_arn        = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "k8s_master_ssm_attach" {
  role              = aws_iam_role.k8s_master_role.name
  policy_arn        = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "k8s_master_s3_attach" {
  role              = aws_iam_role.k8s_master_role.name
  policy_arn        = data.aws_iam_policy.s3.arn
}

resource "aws_iam_role_policy_attachment" "k8s_master_kms_attach" {
  role              = aws_iam_role.k8s_master_role.name
  policy_arn        = aws_iam_policy.kms.arn
}


resource "aws_iam_role_policy_attachment" "k8s_master_generic_attach" {
  role              = aws_iam_role.k8s_master_role.name
  policy_arn        = aws_iam_policy.k8s_master_pol.arn
}
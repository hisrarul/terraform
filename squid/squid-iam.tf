data "aws_iam_policy" "ssm" {
  arn           =   "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_instance_profile" "squid" {
  name          =   format("%s-%s",var.name, var.squid_policy_suffix)
  role          =   aws_iam_role.squid.name
}

resource "aws_iam_role" "squid" {
  name          =   format("%s-%s",var.name, var.squid_role_suffix)
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
  name          =   format("%s-%s",var.name, var.squid_ssm_policy_suffix)
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
resource "aws_iam_role_policy_attachment" "squid-ssm-attach" {
  role              = aws_iam_role.squid.name
  policy_arn        = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "squid-kms-attach" {
  role              = aws_iam_role.squid.name
  policy_arn        = aws_iam_policy.kms.arn
}
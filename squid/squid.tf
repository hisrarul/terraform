data "template_file" "squid" {
  template = "${file("squid_userdata.tpl")}"

  vars = {
    s3_bucket_name = aws_s3_bucket.squid.id
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "squid" {
  id = "${var.vpc_id}"
}

resource "aws_subnet" "squid_subnets" {
  count = length(var.squid_subnets) > 0 ? length(var.squid_subnets) : 0

  cidr_block = var.squid_subnets[count.index]

  availability_zone = element(var.azs, count.index)

  vpc_id = var.vpc_id
  tags = merge(map("Name", format("%s-%s-%s", var.name, var.squid_subnets_suffix, element(var.azs, count.index))), var.tags, var.squid_tags)
}

resource "aws_route_table_association" "squid" {
  count = length(var.squid_subnets) > 0 ? length(var.squid_subnets) : 0
  subnet_id      = aws_subnet.squid_subnets[count.index].id
  route_table_id = var.route_table_public
}

resource "aws_security_group" "squid"{
    name_prefix = format("%s-%s", var.name, var.squid_sg_suffix)
    description     =   "Allow squid"
    vpc_id          =   var.vpc_id
    revoke_rules_on_delete  =   true

    ingress {
        description = "Allow https port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.squid.cidr_block]
    }

    ingress {
        description = "Allow http port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.squid.cidr_block]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(map("Name", format("%s-%s", var.name, var.squid_sg_suffix)), var.tags, var.squid_sg_tags)

}

resource "aws_launch_template" "squid" {
    name            = format("%s-%s", var.name, var.launch_template_suffix)
    image_id        = var.ami_id
    instance_type   = var.instance_type
    iam_instance_profile {
       name = aws_iam_instance_profile.squid.name
    }
    key_name        = var.key_name
    tag_specifications {
        resource_type = "instance"
        tags = merge(map("Name",format("%s-%s-%s",var.name, var.instance_suffix, data.aws_availability_zones.available.names[0])), var.tags, var.launch_template_tag)
    }

    tags = merge(map("Name",format("%s-%s",var.name, var.launch_template_suffix)), var.tags, var.launch_template_tag)
    
    network_interfaces {
        associate_public_ip_address = true
        security_groups             = [aws_security_group.squid.id]
    }
    # user_data = filebase64("example.sh")
    user_data   =   base64encode(data.template_file.squid.rendered)
}
resource "aws_autoscaling_group" "squid-asg-terraform" {
  name               = format("%s-%s", var.name, var.autoscaling_group_suffix)
  depends_on         = [aws_launch_template.squid]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.squid_subnets[0].id]
  launch_template {
            id       = aws_launch_template.squid.id
            version = "$Latest"
  }
}

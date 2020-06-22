data "template_file" "k8s_master" {
  template = "${file("master_userdata.tpl")}"

  vars = {
    S3_BUCKET_NAME = aws_s3_bucket.k8s_s3.id
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "k8s-keypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_launch_template" "k8s_master_lt" {
    name            = format("%s-master-%s", var.name, var.launch_template_suffix)
    image_id        = var.AMIS[var.AWS_REGION]
    instance_type   = var.INSTANCE_TYPE
    iam_instance_profile {
       name = aws_iam_instance_profile.k8s_master_profile.name
    }
    key_name        = aws_key_pair.mykeypair.key_name
    tag_specifications {
        resource_type = "instance"
        tags = merge(map("Name",format("%s-%s-%s",var.name, var.master_instance_suffix, data.aws_availability_zones.available.names[0])), var.tags, var.launch_template_tag, {"kubernetes.io/cluster/k8s-israrul-demo" = "owned"})
    }

    tags = merge(map("Name",format("%s-%s",var.name, var.launch_template_suffix)), var.tags, var.launch_template_tag, {"kubernetes.io/cluster/k8s-israrul-demo" = "owned"})
    
    network_interfaces {
        associate_public_ip_address = true
        security_groups             = [aws_security_group.k8s_master.id]
    }

    user_data   =   base64encode(data.template_file.k8s_master.rendered)
}
resource "aws_autoscaling_group" "k8s_master_asg" {
  name               = format("%s-%s", var.name, var.master_asg_suffix)
  depends_on         = [aws_launch_template.k8s_master_lt]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.k8s_subnet_1.id]
  launch_template {
            id       = aws_launch_template.k8s_master_lt.id
            version = "$Latest"
  }
}

# kubernetes worker

data "template_file" "k8s_worker_tlp" {
  template = "${file("worker_userdata.tpl")}"

  vars = {
    S3_BUCKET_NAME = aws_s3_bucket.k8s_s3.id
  }
}

resource "aws_launch_template" "k8s_worker_lt" {
    depends_on      = [aws_autoscaling_group.k8s_master_asg]
    name            = format("%s-worker-%s", var.name, var.launch_template_suffix)
    image_id        = var.AMIS[var.AWS_REGION]
    instance_type   = var.INSTANCE_TYPE
    iam_instance_profile {
       name = aws_iam_instance_profile.k8s_worker_profile.name
    }
    key_name        = aws_key_pair.mykeypair.key_name
    tag_specifications {
        resource_type = "instance"
        tags = merge(map("Name",format("%s-%s-%s",var.name, var.worker_instance_suffix, data.aws_availability_zones.available.names[0])), var.tags, var.launch_template_tag, {"kubernetes.io/cluster/k8s-israrul-demo" = "owned"})
    }

    tags = merge(map("Name",format("%s-%s",var.name, var.launch_template_suffix)), var.tags, var.launch_template_tag, {"kubernetes.io/cluster/k8s-israrul-demo" = "owned"})
    
    network_interfaces {
        associate_public_ip_address = true
        security_groups             = [aws_security_group.k8s_worker_sg.id]
    }

    user_data   =   base64encode(data.template_file.k8s_worker_tlp.rendered)
}
resource "aws_autoscaling_group" "k8s_worker_asg" {
  name               = format("%s-%s", var.name, var.worker_asg_suffix)
  depends_on         = [aws_launch_template.k8s_worker_lt]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.k8s_subnet_1.id]
  launch_template {
            id       = aws_launch_template.k8s_worker_lt.id
            version = "$Latest"
  }
}
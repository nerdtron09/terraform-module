data "aws_iam_policy_document" "this" {
  statement {
    actions       = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name                       = var.EC2_role.name
  assume_role_policy         = data.aws_iam_policy_document.this.json
  managed_policy_arns        = var.EC2_role.managed_policy_arns
}

resource "aws_iam_instance_profile" "this" {
  name = "EC2-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_launch_configuration" "this" {
  name_prefix                = var.launchconfig.name_prefix
  image_id                   = var.launchconfig.image_id
  instance_type              = var.launchconfig.instance_type
  key_name                   = var.launchconfig.key_pair
  security_groups            = var.launchconfig.security_group_ids
  iam_instance_profile       = aws_iam_instance_profile.this.name
  user_data                  = file(var.launchconfig.userdata_path)

  lifecycle {
    create_before_destroy    = true
  }	
}

resource "aws_autoscaling_group" "this" {
  name                       = var.asg.name_tag
  launch_configuration       = aws_launch_configuration.this.name
  min_size                   = var.asg.min_size
  max_size                   = var.asg.max_size
  desired_capacity           = var.asg.desired_capacity
  vpc_zone_identifier        = var.asg.subnet_ids
  health_check_type          = "ELB"
  health_check_grace_period  = var.asg.hc_grace_period
  target_group_arns          = var.asg.targetgrp_arns

  lifecycle {
    create_before_destroy    = true
  }

  tags = concat(
    [
      {
        "key"                 = "GBL_CLASS_0",
        "value"               = var.asg.GBL_CLASS_0_value,
        "propagate_at_launch" = true
      },
      {
        "key"                 = "GBL_CLASS_1",
        "value"               = var.asg.GBL_CLASS_1_value,
        "propagate_at_launch" = true
      }
    ]
  )
}
variable "EC2_role" {
  type = object({
    name                = string
    managed_policy_arns = list(string)
  })
}

variable "launchconfig" {
  type = object({
    name_prefix         = string
    image_id            = string
    instance_type       = string
    key_pair            = string
    security_group_ids  = list(string)
    userdata_path       = string
  })
}

variable "asg" {
  type = object({
    name_tag            = string
    min_size            = number
    max_size            = number
    desired_capacity    = number
    hc_grace_period     = number
    subnet_ids          = list(string)
    targetgrp_arns      = list(string)
    GBL_CLASS_0_value   = string
    GBL_CLASS_1_value   = string
  })
}
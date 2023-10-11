variable "alb" {
  type = object({
    name_tag           = string 
    sg_ids             = list(string)
    subnets            = list(string)
  })
}

variable "targetgrp" {
  type = object({
    name_tag           = string 
    vpc_id             = string
  })
}



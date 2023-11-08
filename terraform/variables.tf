variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "quantity" {
  description = "number of instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "type to instance"
  type        = string
  default     = "t3.micro"
}

variable "allow_ports" {
  description = "List of ports that are open on the server"
  type        = list
  default     = ["22", "80", "8080"]
}

#variable "enable_monitoring" {
#  description = "enable monitoring instance"
#  type        = bool
#  default     = false
#}

variable "tags" {
  description = "apply tags to all resources"
  type        = map
  default     = {
    Owner     = "DevOps"
    Project   = "Terraform"
  }
}


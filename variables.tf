#environment variables
variable "region" {
description = "value for the region"
default = "eu-west-1"
}

variable "project_name" {
default = "terraform_vpc_demo"
description = "value for the project"
type = string
}

variable "environment" {
default = "dev"
description = "type of environment"
type = string
}

#vpc variables
variable "name" { 
description = "value for the vpc name"
default = "my-vpc"
type = string
 }

variable "cidr" {
default = "10.0.0.0/16"
description = "value for the cidr range"
type = string

}

variable "public_subnets" {
     description = "A list of public subnets"
  type        = list(string)
   default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
variable "private_subnets" {

 description = "A list of private subnets"
  type        = list(string)
   default =  ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "https-security-group" {
  default = "https only"
  type          = string
}

variable "to_https_port" {
  default       = "443"
  description   = "Security group inbound rule to port range"
  type          = string
}
variable "sg_protocol" {
  default       = "TCP"
  description   = "Security group protocol"
  type          = string
}


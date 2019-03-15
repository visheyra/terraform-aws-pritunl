//
// AWS
//

variable "region" {
  description = "region where to deploy the stack"
  type = "string"
  default = ""
}


//
// Global variables
//

variable "name" {
  description = "name of the stack"
  default = ""
  type = "string"
}

variable "tags" {
  description = "tags to be added to all the taggable resources"
  type = "map"
  default = {}
}

//
// DNS
//

variable "dns_zone" {
  description = "name of the dns zone to be used to create record in it"
  default = ""
  type = "string"
}

//
// VPC
//
variable "az" {
  description = "az in which the deployment should occurs"
  type = "string"
  default = ""
}

variable "vpc_cidr" {
  description = "CIDR for the vpc"
  type = "string"
  default = ""
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type = "string"
  default = ""
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  type = "string"
  default = ""
}

//
// Instances
//

variable "instance_size" {
  description = ""
  type = "string"
  default = ""
}

variable ami_id {
  description = ""
  type = "string"
  default = ""
}

variable ami_flavour {
  description = "only amazon_linux_2 is supported"
  type = "string"
  default = ""
}

variable "key_name" {
  description = "name of the ssh key to be used to ssh to host (aws side name)"
  type = "string"
  default = ""
}

//
// VPN
//


variable "allowed_cidrs" {
  description = "list of allowed cidr to add to the security group"
  type = "list"
  default = []
}

variable "additional_vpn_port" {
  description = "list of additional port that should be opened in the sg to allow access to vpn server, only tcp is supported"
  type = "list"
  default = []
}
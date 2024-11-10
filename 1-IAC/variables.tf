# Define variables for our iac

# ProjectId
variable "project_id" {
    type = string
}

# VPC Name
variable "vpc_name" {
  type = string
}

# Subnets for out vpc
variable "subnets" {
  description = "The list of subnets to be created"
  type = list(object({
    name = string
    ip_cidr_range = string
    subnet_region = string
  }))
}

# Source range that should be opened to firewalls
variable "source_ranges" {
    type = list(string)
}

# The list of ports that should be opened 
variable "ports" {
  description = "The list of Ports to be Opened in my vpc"
  type = list(number)
}


variable "instances" {
  description = "Enter the details of the VM"
  type = map(object({
    instance_type = string
    zone = string
    subnet =  string 
  }))
}

variable "vm_user" {
  type = string
}

variable "node_count" {
  type = number
}
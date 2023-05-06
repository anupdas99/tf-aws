variable "region" {
  type        = string
  description = "The region to deploy the infrastructure."
  default     = "us-west-2"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to use for the servers."
  default     = "t2.nano"
}

variable "ami" {
  type        = string
  description = "The type of instance to use for the servers."
  default     = "ami-08d70e59c07c61a3a"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "vpc" {
  description = "Value of VPC"
  type        = string
  default     = "vpc-example"
}


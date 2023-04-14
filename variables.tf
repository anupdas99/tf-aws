variable "region" {
  type        = string
  description = "The region to deploy the infrastructure."
  default     = "us-west-2"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to use for the servers."
  default     = "t2.micro"
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
variable "key-pair" {
  description = "Value of AWS SSH key-pair name"
  type        = string
  default     = "local-key-pair"
}

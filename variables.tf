variable "cidr" {
  description = "cidr value for creating a VPC"
}
variable "instance_type" {
  type = string
  description = "instance type for ec2 instance"
}
variable "AMI" {
  type = string
  description = "AMI for ec2 instance"
}
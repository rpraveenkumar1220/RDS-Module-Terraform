variable "component" {}
variable "env" {}
variable "subnet_ids" {}
variable "engine" {}
variable "engine_version" {}
variable "database_name" {}
variable "kms_key_arn" {}
variable "instance_class" {}
variable "vpc_id" {}
variable "port" {
  default = "3306"
}
variable "sg_subnet_cidr" {}
variable "instance_count" {}




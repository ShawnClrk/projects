variable "vpc_id" {
  description = "ID of PROD VPC"
  type = string
  default = "vpc-00efda9142a9b24d0"
}

variable "security_key_pair" {
    description = "key pair for ec2 instance"
    default = "key-04184cba379eef212"
  
}
variable "public_subnet_id" {
  description = "public ip for ec2 instance"
  default = "subnet-099c89752819851c5"
}

variable "private_subnet_id1" {
    description = "private subnet for rds"
    default = "subnet-0503841e93341e11b"
  
}
variable "private_subnet_id2" {
    description = "private subnet 2"
    default = "subnet-0b825daf7302e3b31"
  
}
variable "database_user" {
    description = "username for database"
    default = "admin"
  
}
variable "database_password" {
  description = "password for database"
  default = "Abcd1234"
}
variable "database_name" {
  description = "name for database"
  default = "wordpressdb"
}
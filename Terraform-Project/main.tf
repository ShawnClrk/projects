terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}

provider "aws" {
 region = "us-east-1"
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"
  description = "EC2 sg to allow ssh, http, and mysql from anywhere"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "rds_sg" {
  name = "rds-sg"
  description = "rds sg to only allow communication from ec2_sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals{
  user_data = templatefile("userdata.sh",{
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.wordpressdb.endpoint
})
}

resource "aws_instance" "wordpress_instance" {
  count = 1
  ami = data.aws_ami.latest_amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = local.user_data
  
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet"
  subnet_ids = [var.private_subnet_id1, var.private_subnet_id2]
}

resource "aws_db_instance" "wordpressdb" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7.43"
  name = var.database_name
  instance_class = "db.t2.micro"
  username = var.database_user
  password = var.database_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id] 
  skip_final_snapshot = true
}
output "ec2_ip" {
  description = "ip of ec2 instance"
  value = aws_instance.wordpress_instance.*.public_ip
}
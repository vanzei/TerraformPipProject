terraform {
  
  required_providers {
    

    aws = {
        source = "hashicorp/aws"
        version = "4.0.0"
    }
  }

  required_version = "~>1.5.5"
}


provider "aws" {
    region = var.aws_region
}

data "aws_availability_zones" "available" {
    state = "available"
}

//VPC name tutorial
resource "aws_vpc" "tutorial_vpc" {

    // seeting the CIDR block tp tje variable defined before
    cidr_block = var.vpc_cidr_block

    enable_dns_hostnames = true
    tags = {
        Name = "tutorial_vpc"
    }
  
}

resource "aws_internet_gateway" "tutorial_igw" {

    vpc_id = aws_vpc.tutorial_vpc.id

    tags = {
        Name  = "tutorial_igw"
    }
}

resource "aws_subnet" "tutorial_public_subnet" {

    //How many resources to create
    count = var.subnet_count.public
    //Putting inside the VPC
    vpc_id = aws_vpc.tutorial_vpc.id
    //Using the CIDR blocks created into the variable, the first will grab the 10.0.1.0/24 and the second the 10.0.2.0/24 since we are creating 2
    cidr_block = var.public_subnet_cidr_blocks[count.index]
    //Using a list defined by the variables and since our region is the us-east-2, we are goin to have 1 subnet in east-2a and other in east-2b
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "tutorial_public_subnet${count.index}"
    }
}

resource "aws_subnet" "tutorial_private_subnet" {

    count = var.subnet_count.private

    vpc_id = aws_vpc.tutorial_vpc.id

    cidr_block = var.private_subnet_cidr_blocks[count.index]

    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "tutorial_private_subnet${count.index}"
    }
}

//Route Table

resource "aws_route_table" "tutorial_public_rt" {

    vpc_id = aws_vpc.tutorial_vpc.id

    route {
        cidr_block = "0.0.0.0/0"

        gateway_id = aws_internet_gateway.tutorial_igw.id
    }
  
}

resource "aws_route_table_association" "public" {

    count = var.subnet_count.public

    route_table_id = aws_route_table.tutorial_public_rt.id

    subnet_id = aws_subnet.tutorial_public_subnet[count.index].id
  
}

resource "aws_route_table" "tutorial_private_rt" {

    vpc_id = aws_vpc.tutorial_vpc.id
  
}

resource "aws_route_table_association" "private" {

    count = var.subnet_count.private

    route_table_id = aws_route_table.tutorial_private_rt.id

    subnet_id = aws_subnet.tutorial_private_subnet[count.index].id
  
}

//EC2 Secutiry Groups

resource "aws_security_group" "tutorial_web_sg" {

    name = "tutorial_web_sg"
    description = "SG for tutorial"
    vpc_id = aws_vpc.tutorial_vpc.id

    //Allowing EC to be open via http, open port 80

    ingress {
        description = "Allow http"
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow ssh from my PC"
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"]
    }

    ingress {
        description = "Allow Airflow from my PC"
        from_port = "8080"
        to_port = "8080"
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"]
    }
    egress {   
        description = "Allow all outbound traffic"
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "tutorial_web_sg"
    }
}

//RDS Secutiry Groups
 

resource "aws_security_group" "tutorial_db_sg" {

    name = "tutorial_db_sg"
    description = "SG for db tutorial"
    vpc_id = aws_vpc.tutorial_vpc.id

    //Allowing EC to be open via http, open port 80

    ingress {
        description = "Allow MYSQL Traffic from the EC2"
        from_port = "3306"
        to_port = "3306"
        protocol = "tcp"
        security_groups = [aws_security_group.tutorial_web_sg.id]
    }
    tags = {
        Name = "tutorial_db_sg"
    }
}


resource "aws_db_subnet_group" "tutorial_db_subnet_group" {

    name = "tutorial_db_subnet_group"
    description = "DB Subnet Group"

    subnet_ids = [for subnet in aws_subnet.tutorial_private_subnet : subnet.id]
  
}

resource "aws_db_instance" "tutorial_database"{

    allocated_storage = var.setting.database.allocated_storage

    engine = var.setting.database.engine

    engine_version = var.setting.database.engine_version

    instance_class = var.setting.database.instance_class

    db_name = var.setting.database.db_name

    username = var.db_username

    password = var.db_password

    db_subnet_group_name = aws_db_subnet_group.tutorial_db_subnet_group.id

    vpc_security_group_ids = [aws_security_group.tutorial_db_sg.id]

    skip_final_snapshot = var.setting.database.skip_final_snapshot
}

resource "aws_key_pair" "tutorial_kp" {

    key_name = "tutorial_kp"

    public_key = file("tutorial_kp.pub")
  
}

data "aws_ami" "ubuntu" {

    most_recent = "true"

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]

    }

    owners = ["099720109477"]

}

resource "aws_instance" "tutorial_web" {

    count = var.setting.web_app.count

    ami = data.aws_ami.ubuntu.id

    instance_type = var.setting.web_app.instance_type

    subnet_id = aws_subnet.tutorial_public_subnet[count.index].id

    key_name = aws_key_pair.tutorial_kp.key_name

    vpc_security_group_ids =  [aws_security_group.tutorial_web_sg.id]


    tags = {
        Name = "tutorial_web_${count.index}"

    }
  
}

resource "aws_eip" "tutorial_web_eip" {

    count = var.setting.web_app.count

    instance = aws_instance.tutorial_web[count.index].id

    vpc = true

    tags = {
        Name = "tutorial_web_eip_${count.index}"
    }
}
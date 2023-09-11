// AWS where everything will be deployed
variable "aws_region" {
    default = "us-east-2"
}

// Setting CIDR Block for VPC

variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

//Holds the n public and private subnets

variable "subnet_count" {
    description = "Number of the subnets"
    type = map(number)
    default = {
      public = 1,
      private = 2
    }
  
}

variable "setting" {
    description = "Config Settings"
    type = map(any)
    default = {
      "database" = {
        allocated_storage = 10
        engine = "mysql"
        engine_version = "8.0.33"
        instance_class = "db.t2.micro"
        db_name = "MySQL1Database"
        skip_final_snapshot = true
      },
      "web_app" = {
        count = 1
        instance_type = "t2.micro"
        }
    
    }
}

//CIDR for private network

variable "public_subnet_cidr_blocks" {
    description = "Available CIDR blocks for public subnets"
    type = list(string)
    default = [ 
        "10.0.1.0/24",
        "10.0.2.0/24",                        
        "10.0.3.0/24",                        
        "10.0.4.0/24",                                      
        ]  
}



variable "private_subnet_cidr_blocks" {
    description = "Available CIDR blocks for private subnets"
    type = list(string)
    default = [ 
        "10.0.101.0/24",
        "10.0.102.0/24",                        
        "10.0.103.0/24",                        
        "10.0.104.0/24",                                      
        ]  
}

variable "my_ip" {
    description = "My IP Address"
    type = string
    sensitive = true
  
}

variable "db_username" {
    description = "Database master user"
    type = string
    sensitive = true
  
}


variable "db_password" {
    description = "Database master password"
    type = string
    sensitive = true
  
}

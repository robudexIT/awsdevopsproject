resource "aws_vpc" "company_vpc" {
  cidr_block = var.vpc_cidr_block[var.region]
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_name
  }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.company_vpc.id
    
    tags  = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.company_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id

    }

    tags = {
        Name = "${var.vpc_name}-public_rt"
    }
}




data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "public_subnet01" {
  vpc_id  = aws_vpc.company_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[1]
  cidr_block =  var.az_subnet_cidr_block[data.aws_availability_zones.available.names[1]]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet01"
  }
}

resource "aws_subnet" "public_subnet02" {
  vpc_id  = aws_vpc.company_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[2]
  cidr_block =  var.az_subnet_cidr_block[data.aws_availability_zones.available.names[2]]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet02"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id  = aws_vpc.company_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[0]
  cidr_block =  var.az_subnet_cidr_block[data.aws_availability_zones.available.names[0]]
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet"
  }
}



resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.company_vpc.id

    # route {
    #     cidr_block = "0.0.0.0/0"
    #     nat_gateway_id =  aws_nat_gateway.company_ngw.id

    # }

    tags = {
        Name = "${var.vpc_name}-private_rt"
    }
}

resource "aws_route_table_association" "public_subnet01_route_table_assoc" {
    subnet_id = aws_subnet.public_subnet01.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet02_route_table_assoc" {
    subnet_id = aws_subnet.public_subnet02.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_route_table_assoc" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}


resource "aws_security_group" "public_sg" {
    name = "public_sg"
    description = "Security Group for public Instance"
    vpc_id = aws_vpc.company_vpc.id 

    ingress {
        description = "Allowed SSH access to trusted to this ip address"
        from_port = 22
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = [var.ssh_location]

    }

    ingress {
        description= "Allowed Http to any ip address source"
        from_port = 80 
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


     ingress {
        description= "Allowed all traffic comming from security group itself"
        from_port = 0
        to_port =  0
        protocol = "-1"
        self = true
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

     tags = {
       Name = "public_sg"
     }


}

resource "aws_security_group" "private_sg" {
    name = "private_sg"
    description = "Security Group for private Instance"
    vpc_id = aws_vpc.company_vpc.id

    ingress {
        description = "Allowed All access to public_sg security group"
        from_port = 0
        to_port = 0
        protocol =  "-1"
        security_groups = [aws_security_group.public_sg.id]

    }

     ingress {
        description= "Allowed all traffic comming from security group itself"
        from_port = 0
        to_port =  0
        protocol = "-1"
        self = true
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

     tags = {
       Name = "private_sg"
     }


}


output "vpc_id" {
   value = aws_vpc.company_vpc.id
}

output "public_subnet01_id" {
    value = aws_subnet.public_subnet01.id
}

output "public_subnet02_id" {
    value = aws_subnet.public_subnet02.id
}

output "private_subnet_id" {
    value = aws_subnet.private_subnet.id
}

output "private_sg_id" {
    value = aws_security_group.private_sg.id
}

output "public_sg_id" {
    value = aws_security_group.public_sg.id
}


output "public_rt_id" {
    value =aws_route_table.public_rt.id
}

output "private_rt_id" {
    value =aws_route_table.private_rt.id
}



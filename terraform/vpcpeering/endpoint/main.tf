resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [var.route_table_id]
  private_dns_enabled = false
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Principal = "*"
        Resource = "*"
      },
    ]
  })

  tags = {
    Environment = "test"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  security_group_ids = [var.security_group_id]
  subnet_ids = [var.subnet_id]
  private_dns_enabled = true
  tags = {
    Environment = "test"
  }
}



resource "aws_vpc_endpoint" "ec2_message" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [var.security_group_id]
  subnet_ids = [var.subnet_id]
  private_dns_enabled = true
  tags = {
    Environment = "test"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  security_group_ids = [var.security_group_id]
  subnet_ids = [var.subnet_id]
   private_dns_enabled = true
  tags = {
    Environment = "test"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [var.security_group_id]
  subnet_ids = [var.subnet_id]
   private_dns_enabled = true
  tags = {
    Environment = "test"
  }
}



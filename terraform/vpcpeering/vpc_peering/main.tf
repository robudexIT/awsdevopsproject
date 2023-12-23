
# Requester's side of the connection.
resource "aws_vpc_peering_connection" "vpc_requester" {
  vpc_id        =  var.vpc_requester_id
  peer_vpc_id   =  var.vpc_accepter_id
  peer_region   = "ap-northeast-3"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}


# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "vpc_accepter" {
 provider = aws.osaka
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_requester.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_route" "route_to_oska_private_cidr" {
    route_table_id  = var.tokyo_private_rt_id
    vpc_peering_connection_id =   aws_vpc_peering_connection.vpc_requester.id
    destination_cidr_block  = var.osaka_private_cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.vpc_accepter ]
}

resource "aws_security_group_rule" "tokyo_private_sg_rule" {
  type              = "ingress"
  description= "Allowed all traffic from osaka subnet of another region"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.osaka_private_cidr_block]
  security_group_id =  var.tokyo_private_sg_id
}

resource "aws_route" "route_to_tokyo_private_cidr" {
    provider = aws.osaka
    route_table_id  = var.osaka_private_rt_id
    vpc_peering_connection_id =   aws_vpc_peering_connection.vpc_requester.id
    destination_cidr_block  = var.tokyo_private_cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.vpc_accepter ]
}

resource "aws_security_group_rule" "osaka_private_sg_rule" {
  provider = aws.osaka
  type              = "ingress"
  description= "Allowed all traffic from tokyo subnet of another region"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.tokyo_private_cidr_block]
  security_group_id =  var.osaka_private_sg_id
}

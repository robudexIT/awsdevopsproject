
module "tokyo_vpc" {
  source   = "./vpc"
  region   = "ap-northeast-1"
  vpc_name = "tokyo_vpc"

}


module "osaka_vpc" {

  providers = {
    aws = aws.osaka
  }
  source   = "./vpc"
  region   = "ap-northeast-3"
  vpc_name = "osaka_vpc"

}


data "aws_subnet" "tokyo_private_subnet" {
  id = module.tokyo_vpc.private_subnet_id
}

data "aws_subnet" "osaka_private_subnet" {
  provider = aws.osaka
  id = module.osaka_vpc.private_subnet_id
}

module "tokyo_osaka_vpc_peering" {
  source = "./vpc_peering"
  vpc_requester_id = module.tokyo_vpc.vpc_id
  vpc_accepter_id =  module.osaka_vpc.vpc_id
  tokyo_private_rt_id = module.tokyo_vpc.private_rt_id
  osaka_private_rt_id = module.osaka_vpc.private_rt_id
  tokyo_private_cidr_block = data.aws_subnet.tokyo_private_subnet.cidr_block
  osaka_private_cidr_block = data.aws_subnet.osaka_private_subnet.cidr_block
  tokyo_private_sg_id = module.tokyo_vpc.private_sg_id
  osaka_private_sg_id = module.osaka_vpc.private_sg_id
}




output "tokyo_vpc_id" {
   value = module.tokyo_vpc.vpc_id
}

output "tokyo_private_route_table_id" {
   value = module.tokyo_vpc.private_rt_id
}

output "tokyo_private_security_group_id" {
   value = module.tokyo_vpc.private_sg_id
}

output "tokyo_private_subnet_id" {
   value = module.tokyo_vpc.private_subnet_id
}



output "osaka_vpc_id" {
   value = module.osaka_vpc.vpc_id
}

output "osaka_private_route_table_id" {
   value = module.osaka_vpc.private_rt_id
}

output "osaka_private_security_group_id" {
   value = module.osaka_vpc.private_sg_id
}

output "osaka_private_subnet_id" {
   value = module.osaka_vpc.private_subnet_id
}




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

# module "tokyo_ec2" {
#     source = "./ec2"
#     region = "ap-northeast-1"
#     instance_name = "tokyo_instance"
#     subnet_id = module.tokyo_vpc.private_subnet_id
#     instance_sg_id = module.tokyo_vpc.private_sg_id
#    #  iam_instance_profile = module.iam.instance_profile_name
# }

# module "osaka_ec2" {
#     source = "./ec2"
#     providers = {
#     aws = aws.osaka
#     }
#     region = "ap-northeast-3"
#     instance_name = "osaka_instance"
#     subnet_id = module.osaka_vpc.private_subnet_id
#     instance_sg_id = module.osaka_vpc.private_sg_id
#    #  iam_instance_profile = module.iam.instance_profile_name
# }




# module "iam" {
#   source = "./iam"
# }


# module "tokyo_vpc_endpoint" {
#    source = "./vpc_endpoint"
#    region = "ap-northeast-1"
#    vpc_id = module.tokyo_vpc.vpc_id
#    security_group_id = module.tokyo_vpc.private_sg_id
#    subnet_id = module.tokyo_vpc.private_subnet_id
#    route_table_id = module.tokyo_vpc.private_rt_id
# }

# module "osaka_vpc_endpoint" {
   
#    source = "./vpc_endpoint"
#    providers = {
#       aws = aws.osaka
#    }
#    region = "ap-northeast-3"
#    vpc_id = module.osaka_vpc.vpc_id
#    security_group_id = module.osaka_vpc.private_sg_id
#    subnet_id = module.osaka_vpc.private_subnet_id
#    route_table_id = module.osaka_vpc.private_rt_id

# }

# output "instance_profile_name"  {
#     value = module.iam.instance_profile_name
# }



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



variable "region" {
   type = string 
   default = "ap-northeast-1"
}


variable "vpc_name" {
  type = string 
  default = "company_vpc"
}

variable "vpc_cidr_block" {
  type = map 
  default = {
    ap-northeast-1 = "192.168.0.0/16"
    ap-northeast-3 = "172.16.0.0/16"
  }
}


variable "az_subnet_cidr_block" {
   type = map  
   default =  {
    ap-northeast-1a = "192.168.10.0/24"
    ap-northeast-1c = "192.168.20.0/24"
    ap-northeast-1d = "192.168.30.0/24"
    ap-northeast-3a = "172.16.10.0/24"
    ap-northeast-3b = "172.16.20.0/24"
    ap-northeast-3c = "172.16.30.0/24"

   }
}

variable "ssh_location" {
  type = string 
  default = "0.0.0.0/0"
}
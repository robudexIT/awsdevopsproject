variable "region" {
  type = string
}

variable "amazon_linux_ami" {
  type  = map 
  default = {
    ap-northeast-1 = "ami-0e347cff037f057c4"
    ap-northeast-3 = "ami-0544908a917e60c74"
  }
}

variable "instance_name" {
    type = string
}

variable "instance_type" {
    type = string 
    default = "t2.micro"
}

# variable "iam_instance_profile" {
#     type = string 
  
# }

variable "instance_sg_id" {
    type = string 
  
}

variable "subnet_id" {
    type = string 
  
}

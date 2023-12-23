resource "aws_instance" "ec2_instance_template" {
  ami = var.amazon_linux_ami[var.region]

  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
    Server = var.instance_name
  }
  # iam_instance_profile = var.iam_instance_profile
  
 
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.instance_sg_id]


}


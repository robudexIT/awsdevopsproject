resource "aws_iam_role" "ec2_private_role" {
    name = "ec2_private_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })

}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_serverpolicy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"  
  role       = aws_iam_role.ec2_private_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_core_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_private_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_proile" {
  name = "ec2_instance_proile"
  role = aws_iam_role.ec2_private_role.name
}


output "instance_profile_name"  {
    value = aws_iam_instance_profile.ec2_instance_proile.name
}


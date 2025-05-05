# This file contains the configuration for creating a public EC2 instance in AWS using Terraform.
resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazon2023.id
  instance_type               = "t2.micro"
  subnet_id                   = flatten(data.aws_subnets.public_sub.ids)[0] #ID of 1 of the public subnets
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  key_name                    = data.aws_key_pair.bastion-key.key_name
  user_data_replace_on_change = true # this forces instance to be recreated upon update of user data contents

  tags = {
    Name = "estee-bastion" #Change to a name you would want your ec2 to be called
  }
}

# This resource is used to create a default EC2 instance metadata options
resource "aws_ec2_instance_metadata_defaults" "enforce-imdsv2" {
  http_tokens                 = "optional"
}



resource "aws_instance" "private" {
  ami                         = data.aws_ami.amazon2023.id
  instance_type               = "t2.micro"
  subnet_id                   = flatten(data.aws_subnets.private_sub.ids)[0]     #ID of 1 of the private subnets
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.webhost_sg.id]
  key_name                    = data.aws_key_pair.web-key.key_name
 #iam_instance_profile        = aws_iam_instance_profile.example.name
  user_data                   = <<EOF
#!/bin/bash 
yum update -y 
yum install httpd -y 
echo "<h1>Hello from Instance $(curl -s 
http://169.254.169.254/latest/meta-data/instance-id)</h1>" | sudo tee 
/var/www/html/index.html 
systemctl start httpd 
systemctl enable httpd 
EOF 
  user_data_replace_on_change = true # this forces instance to be recreated upon update of user data contents

  tags = {
    Name = "estee_tf-ec2-web" #Change to a name you would want your ec2 to be called
  }
}

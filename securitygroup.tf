# This file contains the security group configuration for the bastion host and allow terraform to delete the security group
resource "aws_security_group" "allow_ssh" {
  name        = "estee-security-group-bastion"
  description = "Allow SSH inbound and all outbound"
  vpc_id      = data.aws_vpc.vpcId.id      #VPC Id of the default VPC

  lifecycle {
    prevent_destroy = false  # Ensures Terraform allows deletion
  }

   ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]           # Allows traffic from any IP address
  }

 egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]           # Allows traffic from any IP address
  }

   tags = {
    Name = "bastion_ssh"
  }
}



resource "aws_security_group" "webhost_sg" {
  name        = "estee-security-group-web"
  description = "Allow SSH inbound from bastion and all outbound"
  vpc_id      = data.aws_vpc.vpcId.id      #VPC Id of the default VPC
  
  # Allow inbound traffic only from a specific security group on port 22 (SSH)
  ingress {
    description     = "Allow SSH from trusted bastion group"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh.id]  # Fixed reference to the bastion security group
  }


  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    prevent_destroy = false  # Ensures Terraform allows deletion
  }


  tags = {
    Name = "webhost_sg"
  }
}



resource "aws_security_group" "allow_ssh" {
  name        = "estee-security-group-bastion"
  description = "Allow SSH inbound and all outbound"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "${var.myname}-bastion_ssh"
  }
}

resource "aws_security_group" "webhost_sg" {
  name        = "estee-security-group-web"
  description = "Allow SSH inbound from bastion and all outbound"
  vpc_id      = aws_vpc.my_vpc.id
  
  # Allow inbound traffic only from a specific security group on port 22 (SSH)
  ingress {
    description     = "Allow SSH from trusted bastion group"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh.id]
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
    Name = "${var.myname}-webhost_sg"
  }
}
data "aws_ami" "amazon2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
  owners = ["amazon"]
}

# Use the VPC resource directly instead of data source
output "vpcid_estee" {
  value = aws_vpc.my_vpc.id
}

# Get default route table created with the VPC
data "aws_route_table" "defaultRouteID" {
  vpc_id = aws_vpc.my_vpc.id
  filter {
    name = "association.main"
    values = ["true"]
  }
  depends_on = [aws_vpc.my_vpc]
}

output "defaultroute" {
  value = data.aws_route_table.defaultRouteID.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Key pairs
data "aws_key_pair" "bastion-key" {
  key_name = "estee-ec2-key"
}

output "bastionkeyname" {
  value = data.aws_key_pair.bastion-key.key_name
}

data "aws_key_pair" "web-key" {
  key_name = "estee-privkey"
}

output "privkeyname" {
  value = data.aws_key_pair.web-key.key_name
}

# Output subnet information directly from the resources instead of using data sources
output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "subnet_names" {
  value = {
    for subnet in aws_subnet.public_subnets :
    subnet.id => subnet.tags["Name"]
  }
}
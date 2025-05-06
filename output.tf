#query to read latest Amazon Linux 2023 AMI
data "aws_ami" "amazon2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
  owners = ["amazon"]
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

#get aws availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

/*
# Key pairs
data "aws_key_pair" "bastion-key" {
  key_name = "estee-bastion-key"
}

data "aws_key_pair" "web-key" {
  key_name = "estee-privkey"
}
*/





# Use the VPC resource directly instead of data source
output "vpcid_estee" {
  value = aws_vpc.my_vpc.id
}

#check default route table info
output "defaultroute" {
  value = data.aws_route_table.defaultRouteID.id
}


data "aws_nat_gateways" "existing_nat_gw" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

#get ngw id or return null if not found
output "nat_gateway_id" {
  value = length(data.aws_nat_gateways.existing_nat_gw.ids) > 0 ? data.aws_nat_gateways.existing_nat_gw.ids[0] : "[]"
}



# Output subnet information directly from the resources instead of using data sources
# check public subnets info
output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "subnet_names_public" {
  value = {
    for subnet in aws_subnet.public_subnets :
    subnet.id => subnet.tags["Name"]
  }
}

# check private subnets info
output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "subnet_names_private" {
  value = {
    for subnet in aws_subnet.private_subnets :
    subnet.id => subnet.tags["Name"]
  }
}

# Get Bastion instance information
output "bastion_instance_ip" {
  value = aws_instance.public.public_ip
}

output "bastion_instance_dns" {
  value = aws_instance.public.public_dns
}

# Get Bastion instance information
output "private_instance_ip" {
  value = aws_instance.private.private_ip
}

output "private_instance_dns" {
  value = aws_instance.private.private_dns
}

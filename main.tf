#create VPC
resource "aws_vpc" "my_vpc" {
 cidr_block = var.myvpc_cidr
 
 tags = {
   Name = "estee_terraform_vpc"
 }
}

#create 9 subnets, 3-tier in 3 azs
resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Estee Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
  
 tags = {
   Name = "Estee Private Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "database_subnets" {
 count      = length(var.database_subnet_cidrs)
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = element(var.database_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)

 tags = {
   Name = "Estee Database Subnet ${count.index + 1}"
 }
}

#create igw
resource "aws_internet_gateway" "my_igw" {
 vpc_id = aws_vpc.my_vpc.id
 
 tags = {
   Name = "Estee IGW"
 }
}

#Create public route
resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.my_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.my_igw.id
 }
 
 tags = {
   Name = "Estee Public Route Table for Internet Routing"
 }
}

#associate public subnets with public route
resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}

#generate EIP for nat GW
resource "aws_eip" "nat" {
  domain = "vpc"
}

#Create one NAT Gateway in the first public subnet using the allocated Elastic IP
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id
  
  tags = {
    Name = "estee nat gw"
  }
}

#Create private route
resource "aws_route_table" "private_rt" {
 vpc_id = aws_vpc.my_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.natgw.id
 }
 
 tags = {
   Name = "Estee nat gw private route"
 }
}

#associate private  subnets with private route
resource "aws_route_table_association" "private_subnet_asso" {
 count = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.private_rt.id
}

#get current VPC ID
data "aws_vpc" "vpcId" {
  filter {
    name   = "tag:Name"
    values = ["estee_terraform_vpc"]  # Replace with your actual VPC name
  }
}

output "vpcid_estee" {
  value = data.aws_vpc.vpcId.id
}

#get default route ID
data "aws_route_table" "defaultRouteID" {
  vpc_id = data.aws_vpc.vpcId.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}

output "defaultroute" {
  value = data.aws_route_table.defaultRouteID.id
}

data "aws_ami" "amazon2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
  owners = ["amazon"]
}

/*
data "aws_subnets" "public" {
 filter {
  name = "tag:Name"
  values = ["Estee Public *"]
 }
}


output "test"{
  value =data.aws_subnets.public.ids
}
*/

data "aws_subnets" "public_sub" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpcId.id]        # Use the dynamically retrieved VPC ID
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]                       # Ensures only public subnets are returned
  }
}

data "aws_subnet" "each_subnet" {
  for_each = toset(data.aws_subnets.public_sub.ids) # Use the IDs of the public subnets

  id = each.value
}

/*
output "subnet_name" {
  value = data.aws_subnets.public_sub.tags["Name"]
}*/

output "subnet_names" {
  value = { for subnet_id in data.aws_subnet.each_subnet : subnet_id.id => subnet_id.tags["Name"] }
}

data "aws_subnets" "private_sub" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpcId.id]        # Use the dynamically retrieved VPC ID
  }

 filter {
  name = "tag:Name"
  values = ["Estee Private *"]
 }
}


data "aws_availability_zones" "available" {
  state = "available"
}



#play cheat for now and use console to create key pair
data "aws_key_pair" "bastion-key" {
  key_name           = "estee-ec2-key"
}

output "bastionkeyname" {
  value = data.aws_key_pair.bastion-key.key_name
}

data "aws_key_pair" "web-key" {
  key_name           = "estee-privkey"
}

output "privkeyname" {
  value = data.aws_key_pair.web-key.key_name
}


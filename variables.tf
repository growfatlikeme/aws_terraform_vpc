
variable "myvpc_cidr" {
 type        = string
 description = "VPC CIDR range"
 default     = "172.168.16.0/20"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["172.168.17.0/24", "172.168.18.0/24", "172.168.19.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["172.168.20.0/24", "172.168.21.0/24", "172.168.22.0/24"]
}

variable "database_subnet_cidrs" {
 type        = list(string)
 description = "Database Subnet CIDR values"
 default     = ["172.168.23.0/24", "172.168.24.0/24", "172.168.25.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}
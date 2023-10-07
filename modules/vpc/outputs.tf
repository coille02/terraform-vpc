# output.tf 

# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.r-vpc[0].id, "")
}

output "m_vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.m-vpc[0].id, "")
}

output "q_vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.q-vpc[0].id, "")
}

output "vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(aws_vpc.r-vpc[0].cidr_block, "")

}
output "m_vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(aws_vpc.m-vpc[0].cidr_block, "")
}

output "q_vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = try(aws_vpc.q-vpc[0].cidr_block, "")
}

output "default_security_group_id" {
  description = "VPC default Security Group ID"
  value       = aws_vpc.r-vpc.*.default_security_group_id
}

# internet gateway
output "r_igw_id" {
  description = "Real Interget Gateway ID"
  value       = try(aws_internet_gateway.r_igw[0].id, "")
}

output "m_igw_id" {
  description = "Manage Interget Gateway ID"
  value       = try(aws_internet_gateway.m_igw[0].id, "")
}

output "q_igw_id" {
  description = "QA Interget Gateway ID"
  value       = try(aws_internet_gateway.q_igw[0].id, "")
}

# subnets
output "r_private_subnets_ids" {
  description = "Private Subnet ID 리스트"
  value       = aws_subnet.r-sn-private.*.id
}

output "r_public_subnets_ids" {
  description = "Public Subnet ID 리스트"
  value       = aws_subnet.r-sn-public.*.id
}


output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_db_subnet_group.r-sn-db[0].name, "")
}

output "redis_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_elasticache_subnet_group.r-sn-redis[0].name, "")
}

output "q_redis_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_elasticache_subnet_group.q-sn-redis[0].name, "")
}

output "q_aws_db_subnet_group_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = aws_subnet.q-sn-public.*.id
}

output "q_subnets_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = aws_subnet.q-sn-public.*.id
}

output "m_subnets_ids" {
  description = "Database Subnet Group ID ID 리스트"
  value       = aws_subnet.m-sn-public.*.id
}

# route tables
output "public_route_table_ids" {
  description = "Public Route Table ID 리스트"
  value       = try(aws_default_route_table.r-rtb-public[*].id, "")
}

output "private_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(aws_route_table.r-rtb-private[*].id, "")
}

output "m_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(aws_default_route_table.m-rtb-public[0].id, "")
}

output "q_route_table_ids" {
  description = "Private Route Table ID 리스트"
  value       = try(aws_default_route_table.q-rtb-public[0].id, "")
}

# NAT gateway

output "nat_ids" {
  description = "NAT Gateway에 할당된 EIP ID 리스트"
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = "NAT Gateway에 할당된 EIP 리스트"
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = "NAT Gateway ID 리스트"
  value       = aws_nat_gateway.r-ngw.*.id
}



# main.tf
locals {
  create_r_vpc      = var.create_r_vpc
  create_m_vpc      = var.create_m_vpc
  create_q_vpc      = var.create_q_vpc
  m_route_table_ids = aws_default_route_table.m-rtb-public[*].id
  q_route_table_ids = aws_default_route_table.q-rtb-public[*].id
  r_route_table_ids = concat(aws_default_route_table.r-rtb-public[*].id, aws_route_table.r-rtb-private[*].id)
  q_env             = var.q_env
  m_env             = var.m_env
  r_env             = var.r_env
  game_code         = var.game_code
  q_game_code       = var.q_game_code == null ? var.game_code : var.q_game_code
  m_game_code       = var.m_game_code == null ? var.game_code : var.m_game_code
  r_game_code       = var.r_game_code == null ? var.game_code : var.r_game_code
  q_owner_id        = var.q_owner_id
  q_access_key      = var.q_access_key
  q_secret_key      = var.q_secret_key
  q_session_token   = var.q_session_token
  q_region          = var.q_region == null ? null : var.q_region
  m_region          = var.m_region == null ? var.aws_region : var.m_region
  r_region          = var.r_region == null ? var.aws_region : var.r_region
}

# VPC
data "aws_caller_identity" "current" {}

provider "aws" {
  alias  = "real"
  region = try(local.m_region, local.r_region)

}

provider "aws" {
  alias  = "qa"
  region = var.q_region

  access_key = try(local.q_access_key, null)
  secret_key = try(local.q_secret_key, null)
  token      = try(local.q_session_token, null)
}


resource "aws_vpc" "r-vpc" {
  count = local.create_r_vpc ? 1 : 0

  cidr_block           = var.r_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "r-vpc-${var.game_code}-${var.region}"
  }
}

resource "aws_vpc" "q-vpc" {
  count                = local.create_q_vpc ? 1 : 0
  provider             = aws.qa
  cidr_block           = var.q_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "q-vpc-${var.game_code}-${var.region}"
  }
}

resource "aws_vpc" "m-vpc" {
  count = local.create_m_vpc ? 1 : 0

  cidr_block           = var.m_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "m-vpc-${var.game_code}-${var.region}"
  }
}

# internet gateway
resource "aws_internet_gateway" "q_igw" {
  count = local.create_q_vpc ? 1 : 0

  provider = aws.qa
  vpc_id   = aws_vpc.q-vpc[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("q-igw-%s-%s", var.game_code, var.region)
    },
  )
}

resource "aws_internet_gateway" "m_igw" {
  count = local.create_m_vpc ? 1 : 0

  vpc_id = aws_vpc.m-vpc[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("m-igw-%s-%s", var.game_code, var.region)
    },
  )
}

resource "aws_internet_gateway" "r_igw" {
  count = local.create_r_vpc ? 1 : 0

  vpc_id = aws_vpc.r-vpc[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("r-igw-%s-%s", var.game_code, var.region)
    },
  )
}

# public subnet
resource "aws_subnet" "r-sn-public" {
  count = local.create_r_vpc ? length(var.r_public_subnets) : 0

  # count = length(var.r_public_subnets)

  vpc_id                  = aws_vpc.r-vpc[0].id
  cidr_block              = var.r_public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name"   = format("r-sn-%s-public-%s", var.game_code, var.azs[count.index])
      "subnet" = "r-sn-public"
    },
  )
}

resource "aws_subnet" "q-sn-public" {
  count = local.create_q_vpc ? length(var.q_public_subnets) : 0

  # count = length(var.q_public_subnets)
  provider                = aws.qa
  vpc_id                  = aws_vpc.q-vpc[0].id
  cidr_block              = var.q_public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name"   = format("q-sn-%s-public-%s", var.game_code, var.azs[count.index])
      "subnet" = "q-sn-public"
    },
  )
}

resource "aws_subnet" "m-sn-public" {
  count = local.create_m_vpc ? length(var.m_public_subnets) : 0

  # count = length(var.m_public_subnets)

  vpc_id                  = aws_vpc.m-vpc[0].id
  cidr_block              = var.m_public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name"   = format("m-sn-%s-public-%s", var.game_code, var.azs[count.index])
      "subnet" = "m-sn-public"
    },
  )
}

# private subnet
resource "aws_subnet" "r-sn-private" {
  count = local.create_r_vpc ? length(var.r_private_subnets) : 0

  # count = length(var.r_private_subnets)

  vpc_id            = aws_vpc.r-vpc[0].id
  cidr_block        = var.r_private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      "Name"   = format("r-sn-%s-private-%s", var.game_code, var.azs[count.index])
      "subnet" = "r-sn-private"
    },
  )
}

# database subnet

resource "aws_db_subnet_group" "r-sn-db" {
  count = local.create_r_vpc && length(var.r_private_subnets) > 0 ? 1 : 0

  name        = "r-sn-db-${var.game_code}"
  description = "Database subnet group for ${var.game_code}-terraform"
  subnet_ids  = aws_subnet.r-sn-private.*.id

  tags = merge(
    var.tags,
    {
      "Name" = format("r-sn-%s-rds", var.game_code)
    },
  )
}

resource "aws_db_subnet_group" "q-sn-db" {
  count       = local.create_q_vpc && length(var.q_public_subnets) > 0 ? 1 : 0
  provider    = aws.qa
  name        = "q-sn-db-${var.game_code}"
  description = "Database subnet group for ${var.game_code}-terraform"
  subnet_ids  = aws_subnet.q-sn-public.*.id

  tags = merge(
    var.tags,
    {
      "Name" = format("q-sn-%s-rds", var.game_code)
    },
  )
}

# # elasticache subnet

resource "aws_elasticache_subnet_group" "r-sn-redis" {
  count = local.create_r_vpc && length(var.r_private_subnets) > 0 ? 1 : 0

  name        = "r-sn-redis-${var.game_code}"
  description = "ElastiCache subnet group for ${var.game_code} by terraform"
  subnet_ids  = aws_subnet.r-sn-private.*.id
}

resource "aws_elasticache_subnet_group" "q-sn-redis" {
  count       = local.create_q_vpc && length(var.q_public_subnets) > 0 ? 1 : 0
  provider    = aws.qa
  name        = "q-sn-redis-${var.game_code}"
  description = "ElastiCache subnet group for ${var.game_code} by terraform"
  subnet_ids  = aws_subnet.q-sn-public.*.id
}

# EIP for NAT gateway
resource "aws_eip" "nat" {
  count = local.create_r_vpc ? length(var.azs) : 0

  # count = length(var.azs)

  vpc = true

  tags = merge(
    var.tags,
    {
      "Name" = format("r-%s-ngw-eip-%s", var.game_code, var.azs[count.index])
    },
  )
}

# NAT gateway
resource "aws_nat_gateway" "r-ngw" {
  count = local.create_r_vpc ? length(var.azs) : 0

  # count = length(var.azs)

  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.r-sn-public.*.id[count.index]
  #allocation_id = aws_eip.nat.id
  #subnet_id     = aws_subnet.r-sn-public[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("r-%s-ngw-%s", var.game_code, var.azs[count.index])
    },
  )
}

# default network ACL
resource "aws_default_network_acl" "r_default" {
  count = local.create_r_vpc ? 1 : 0

  default_network_acl_id = aws_vpc.r-vpc[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = null

  tags = merge(
    var.tags,
    {
      "Name" = format("r-%s-default", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_network_acl" "q_default" {
  count                  = local.create_q_vpc ? 1 : 0
  provider               = aws.qa
  default_network_acl_id = aws_vpc.q-vpc[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = null

  tags = merge(
    var.tags,
    {
      "Name" = format("q-%s-default", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_network_acl" "m_default" {
  count = local.create_m_vpc ? 1 : 0

  default_network_acl_id = aws_vpc.m-vpc[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # subnet_ids = aws_subnet.m-sn-public.*.id
  subnet_ids = null


  tags = merge(
    var.tags,
    {
      "Name" = format("m-%s-default", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

# public route table
resource "aws_default_route_table" "q-rtb-public" {
  count                  = local.create_q_vpc ? 1 : 0
  provider               = aws.qa
  default_route_table_id = aws_vpc.q-vpc[0].default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.q_igw[0].id
  }

  # route {
  #   cidr_block                = aws_vpc.m-vpc.cidr_block
  #   vpc_peering_connection_id = aws_vpc_peering_connection.m-to-q.id
  # }

  tags = merge(
    var.tags,
    {
      "Name" = format("q-rtb-%s-public", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_default_route_table" "m-rtb-public" {
  count = local.create_m_vpc ? 1 : 0

  default_route_table_id = aws_vpc.m-vpc[0].default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.m_igw[0].id
  }

  # route {
  #   cidr_block                = aws_vpc.q-vpc.cidr_block
  #   vpc_peering_connection_id = aws_vpc_peering_connection.m-to-q.id
  # }

  # route {
  #   cidr_block                = aws_vpc.r-vpc.cidr_block
  #   vpc_peering_connection_id = aws_vpc_peering_connection.m-to-r.id
  # }

  tags = merge(
    var.tags,
    {
      "Name" = format("m-rtb-%s-public", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_default_route_table" "r-rtb-public" {
  count = local.create_r_vpc ? 1 : 0

  default_route_table_id = aws_vpc.r-vpc[0].default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.r_igw[0].id
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("r-rtb-%s-public", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}

# private route table
resource "aws_route_table" "r-rtb-private" {
  count = local.create_r_vpc ? length(var.azs) : 0

  vpc_id = aws_vpc.r-vpc[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.r-ngw.*.id[count.index]
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("r-rtb-%s-private-%s", var.game_code, var.azs[count.index])
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}


# route table association
resource "aws_route_table_association" "r-rtb-public" {
  count = local.create_r_vpc ? length(var.r_public_subnets) : 0

  subnet_id      = aws_subnet.r-sn-public[count.index].id
  route_table_id = aws_default_route_table.r-rtb-public[0].id
}

resource "aws_route_table_association" "r-rtb-private" {
  count = local.create_r_vpc ? length(var.r_private_subnets) : 0

  subnet_id      = aws_subnet.r-sn-private.*.id[count.index]
  route_table_id = aws_route_table.r-rtb-private.*.id[count.index]
}


resource "aws_route_table_association" "q-rtb-public" {
  count          = local.create_q_vpc ? length(var.q_public_subnets) : 0
  provider       = aws.qa
  subnet_id      = aws_subnet.q-sn-public[0].id
  route_table_id = aws_vpc.q-vpc[0].default_route_table_id
}

resource "aws_route_table_association" "m-rtb-public" {
  count = local.create_m_vpc ? length(var.m_public_subnets) : 0

  subnet_id      = aws_subnet.m-sn-public[count.index].id
  route_table_id = aws_vpc.m-vpc[0].default_route_table_id
}

#Peering
# Requester's side of the connection.
resource "aws_vpc_peering_connection" "qa" {
  count         = local.create_m_vpc && local.create_q_vpc ? 1 : 0
  provider      = aws.real
  vpc_id        = aws_vpc.m-vpc[0].id
  peer_vpc_id   = aws_vpc.q-vpc[0].id
  peer_owner_id = try(local.q_owner_id, data.aws_caller_identity.current.account_id)
  peer_region   = local.q_region
  auto_accept   = false

  tags = {
    Name = format("peering-(%s-%s-${local.q_region})-(%s-%s-${local.m_region})", local.q_env, local.q_game_code, local.m_env, local.m_game_code)


  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "qa" {
  count                     = local.create_m_vpc && local.create_q_vpc ? 1 : 0
  provider                  = aws.qa
  vpc_peering_connection_id = aws_vpc_peering_connection.qa[0].id
  auto_accept               = true

  tags = {
    Name = format("peering-(%s-%s-${local.q_region})-(%s-%s-${local.m_region})", local.q_env, local.q_game_code, local.m_env, local.m_game_code)
  }
}

resource "aws_vpc_peering_connection" "real" {
  count       = local.create_m_vpc && local.create_r_vpc ? 1 : 0
  provider    = aws.real
  vpc_id      = aws_vpc.m-vpc[0].id
  peer_vpc_id = aws_vpc.r-vpc[0].id
  peer_region = local.r_region
  auto_accept = false

  tags = {
    Name = format("peering-(%s-%s-${local.r_region})-(%s-%s-${local.m_region})", local.r_env, local.r_game_code, local.r_env, local.m_game_code)


  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "real" {
  count                     = local.create_m_vpc && local.create_r_vpc ? 1 : 0
  provider                  = aws.real
  vpc_peering_connection_id = aws_vpc_peering_connection.real[0].id
  auto_accept               = true

  tags = {
    Name = format("peering-(%s-%s-${local.r_region})-(%s-%s-${local.m_region})", local.r_env, local.r_game_code, local.r_env, local.m_game_code)
  }
}

resource "aws_route" "route_m_q" {
  count                     = local.create_m_vpc && local.create_q_vpc ? 1 : 0
  provider                  = aws.real
  route_table_id            = aws_default_route_table.m-rtb-public[count.index].id
  destination_cidr_block    = aws_vpc.q-vpc[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.qa[0].id
}

resource "aws_route" "route_q_m" {
  count                     = local.create_m_vpc && local.create_q_vpc ? 1 : 0
  provider                  = aws.qa
  route_table_id            = aws_default_route_table.q-rtb-public[count.index].id
  destination_cidr_block    = aws_vpc.m-vpc[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.qa[0].id
}

resource "aws_route" "route_m_r" {
  count                     = local.create_m_vpc && local.create_r_vpc ? 1 : 0
  provider                  = aws.real
  route_table_id            = aws_default_route_table.m-rtb-public[count.index].id
  destination_cidr_block    = aws_vpc.r-vpc[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.real[0].id
}

resource "aws_route" "route_r_m" {
  count                     = local.create_m_vpc && local.create_r_vpc ? 3 : 0
  provider                  = aws.real
  route_table_id            = concat(aws_default_route_table.r-rtb-public[*].id, aws_route_table.r-rtb-private[*].id)[count.index]
  destination_cidr_block    = aws_vpc.m-vpc[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.real[0].id
}


resource "aws_vpc_peering_connection_options" "q_m" {
  count                     = local.create_m_vpc && local.create_q_vpc ? 1 : 0
  provider                  = aws.real
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.qa[0].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "m_q" {
  count                     = local.create_m_vpc && local.create_q_vpc ? 1 : 0
  provider                  = aws.qa
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.qa[0].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "m_r" {
  count                     = local.create_m_vpc && local.create_r_vpc ? 1 : 0
  provider                  = aws.real
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.real[0].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "r_m" {
  count                     = local.create_m_vpc && local.create_r_vpc ? 1 : 0
  provider                  = aws.real
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.real[0].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

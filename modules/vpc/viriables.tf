# variables.tf

variable "create_r_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_m_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_q_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

# variable "game_code" {
#   description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
#   type        = string
# }

variable "region" {
  description = "국가코드"
  type        = string
}

variable "r_cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
  default     = "10.15.0.0/21"
}

variable "q_cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
  default     = "10.15.0.0/21"
}

variable "m_cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
  default     = "10.15.0.0/21"
}

variable "r_public_subnets" {
  description = "Real Public Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "q_public_subnets" {
  description = "QA Public Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "m_public_subnets" {
  description = "Manage Public Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "r_private_subnets" {
  description = "Real Private Subnet IP 리스트"
  type        = list(string)
  default     = ["10.15.2.0/24", "10.15.1.0/24"]
}

variable "azs" {
  description = "사용할 availability zones 리스트"
  type        = list(string)
}

variable "tags" {
  description = "모든 리소스에 추가되는 tag 맵"
  type        = map(string)
}

# variable "q_access_key" {
#   description = "qa_access_key"
#   type        = string
#   default     = null
# }

# variable "q_secret_key" {
#   description = "qa_secret_key"
#   type        = string
#   default     = null
# }

# variable "q_session_token" {
#   description = "qa_session_token"
#   type        = string
#   default     = null
# }

# variable "q_region" {
#   description = "qa region"
#   type        = string
#   default     = null
# }


#Peering
# variable "create_m_q_peering" {
#   description = "create_m_vpc"
#   type        = bool
#   default     = false
# }

# variable "create_m_r_peering" {
#   description = "create_m_vpc"
#   type        = bool
#   default     = false
# }

# variable "q_vpc_id" {
#   description = "qa vpc id"
#   type        = string
#   default     = null
# }
# variable "m_vpc_id" {
#   description = "manage vpc id"
#   type        = string
#   default     = null
# }
# variable "r_vpc_id" {
#   description = "real vpc id"
#   type        = string
#   default     = null
# }

variable "r_region" {
  description = "real region"
  type        = string
  default     = null
}
variable "q_region" {
  description = "qa region"
  type        = string
  default     = null
}

variable "m_region" {
  description = "qa region"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "aws default region"
  type        = string
  default     = null
}

variable "q_env" {
  description = "qa env"
  type        = string
  default     = "q"
}
variable "m_env" {
  description = "manage env"
  type        = string
  default     = "M"
}

variable "r_env" {
  description = "manage env"
  type        = string
  default     = "r"
}

# variable "m_route_table_ids" {
#   type = list(string)
# }
# variable "q_route_table_ids" {
#   type = list(string)
# }

# variable "private_route_table_ids" {
#   type = list(string)
# }

# variable "public_route_table_ids" {
#   type = list(string)
# }

# variable "m_cidr_block" {
#   description = "manage env"
#   type        = string
#   default     = null
# }

# variable "q_cidr_block" {
#   description = "manage env"
#   type        = string
#   default     = null
# }

# variable "r_cidr_block" {
#   description = "manage env"
#   type        = string
#   default     = null
# }

variable "game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
  default     = null
}

variable "q_game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
  default     = null
}

variable "m_game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
  default     = null
}
variable "r_game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
  default     = null
}

variable "q_owner_id" {
  description = "accept account id"
  type        = string
  default     = null
}

variable "q_access_key" {
  description = "accept_access_key"
  type        = string
  default     = null
}

variable "q_secret_key" {
  description = "accept_secret_key"
  type        = string
  default     = null
}

variable "q_session_token" {
  description = "accept_session_token"
  type        = string
  default     = null
}

variable "create_r_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

variable "create_q_vpc" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = bool
  default     = false
}

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

variable "game_code" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
}

variable "name" {
  description = "Name of the parameter group"
}

variable "family" {
  description = "The family of the parameter group"
}

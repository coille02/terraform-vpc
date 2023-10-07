locals {
  # VPC 생성 여부 결정
  create_r_vpc = true
  create_m_vpc = true
  create_q_vpc = true

  # Peering 생성 여부 결정
  # create_m_vpc && create_q_vpc 이면 m_q peering 자동생성
  # create_m_vpc && create_r_vpc 이면 m_r peering 자동생성

  # 환경 설정
  game_code  = "rnd"
  country    = "kr"
  aws_region = "ap-northeast-2"

  # VPC CIDR 입력
  r_cidr = "10.6.0.0/21"
  q_cidr = "10.6.8.0/23"
  m_cidr = "10.6.10.0/23"

  # VPC의 Real Public Subnet CIDR block을 정의한다.
  r_public_subnets = ["10.6.0.0/24", "10.6.2.0/24"]

  # VPC의 Real Private Subnet CIDR block을 정의한다.
  r_private_subnets = ["10.6.4.0/24", "10.6.6.0/24"]

  # VPC의 QA Subnet CIDR block을 정의한다.
  q_public_subnets = ["10.6.8.0/24", "10.6.9.0/24"]

  # VPC의 Manage Subnet CIDR block을 정의한다.
  m_public_subnets = ["10.6.10.0/24", "10.6.11.0/24"]

  # QA 계정을 생성할경우만 변경하여 입력
  # QA 생성시 계정이 말료되어 에러가 나면 새로 교체 진행
  q_owner_id      = "계정 ID"
  q_access_key    = "엑세스키 입력"
  q_secret_key    = "시크릿키 입력"
  q_session_token = "시크릿 토큰 입력"


  # 이후 아래값은 수정하지 않음---------------------------------------------
  q_game_code = local.game_code
  m_game_code = local.game_code
  r_game_code = local.game_code
  m_region    = "ap-northeast-2"
  q_region    = local.aws_region
  r_region    = local.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  create_r_vpc      = local.create_r_vpc
  create_m_vpc      = local.create_m_vpc
  create_q_vpc      = local.create_q_vpc
  game_code         = local.game_code
  region            = local.country
  r_cidr            = local.r_cidr
  q_cidr            = local.q_cidr
  m_cidr            = local.m_cidr
  azs               = ["${local.aws_region}a", "${local.aws_region}c"]
  r_public_subnets  = local.r_public_subnets
  r_private_subnets = local.r_private_subnets
  q_public_subnets  = local.q_public_subnets
  m_public_subnets  = local.m_public_subnets
  q_owner_id        = local.q_owner_id
  q_access_key      = local.q_access_key
  q_secret_key      = local.q_secret_key
  q_session_token   = local.q_session_token
  q_game_code       = local.q_game_code
  m_game_code       = local.m_game_code
  r_game_code       = local.r_game_code
  q_region          = local.q_region
  m_region          = local.m_region
  r_region          = local.r_region

  tags = {
    "TerraformManaged" = "true"
  }
}

module "rds" {
  source = "../../modules/rds"

  #DB parameter group
  create_r_vpc    = local.create_r_vpc
  create_q_vpc    = local.create_q_vpc
  q_access_key    = local.q_access_key
  q_secret_key    = local.q_secret_key
  q_session_token = local.q_session_token
  q_region        = local.q_region
  m_region        = local.m_region
  r_region        = local.r_region

  game_code = local.game_code
  name      = local.game_code
  family    = "aurora5.7" # 변경하지 않는다.
}



# terraform-vpc
<img src="./multi account vpc.png">
사용법
1. ./common 프로젝트 디렉토리 생성
2. ./common/rnd/폴더를 복사하여 사용
3. ./common/신규생성 디렉토리/ 의 provider.tf를 만들고 iam 생성 하거나, 터미널에서 키정보를 입력하고 실행
provider "aws" {
  access_key = "xxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxx"
  region     = "ap-northeast-1"(생성할 리전)
}

4./common/신규생성 디렉토리/에 들어가서 명령어 실행
terraform get
terraform init
terraform plan
terraform apply

2023-01-13
모듈이 업데이트 되어 ET 프로젝트롤 복사해서 사용
QA, Real 계정이 틀린경우에도 생성됨!!
provider에 키를 넣지 않고 llz의 Command line or programmatic access를 복사하여 실행시킴

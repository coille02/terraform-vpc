# Multi-Account Terraform VPC 설정 가이드
<img src="./multi account vpc.svg">

## 개요

이 문서는 제공된 Terraform 모듈을 사용하여 여러 AWS 계정에서 VPC를 설정하는 방법에 대한 지침을 제공합니다. 이 방법론은 QA와 Real 계정이 다르더라도 성공적으로 설정할 수 있습니다.
backend를 의도적으로 디렉토리에 받게 해놨기때문에 여러명이 사용하려면 backend를 s3로 변경해야합니다.

## 사전 요구 사항

- 시스템에 Terraform 설치
- AWS CLI 설정
- 적절한 IAM 권한

## 설정 지침

### 1. 프로젝트 디렉토리 생성
```bash
mkdir ./common
```
### 2. 참조 디렉토리 복사
RND 디렉토리를 복사하세요:
```bash
Copy code
cp -r ./common/rnd/ ./common/{새로운_디렉토리_이름}/
```
### 3. AWS 제공자 설정
새 디렉토리로 이동하세요:

```bash
Copy code
cd ./common/{새로운_디렉토리_이름}/
```

provider.tf 파일을 다음 내용으로 생성하거나 수정하세요:

```hcl
Copy code
provider "aws" {
  access_key = "당신의_AWS_접근_키"
  secret_key = "당신의_AWS_비밀_키"
  region     = "ap-northeast-1" # 원하는 리전으로 변경하세요
}
```

참고: AWS 자격증명을 Terraform 파일 외부에서 관리하는 것이 보안상 더 좋습니다. AWS CLI를 설정하거나 환경 변수를 사용하여 이를 수행할 수 있습니다. 2023-01-13의 최신 업데이트에서는 키를 직접 제공자에 임베드 할 필요가 없으며 대신 aws configure 명령을 사용하거나 AWS IAM의 Command Line 또는 Programmatic Access 섹션에서 제공되는 키를 사용할 수 있습니다.

### 4. Terraform 구성 초기화 및 적용
다음 명령을 차례대로 실행하세요:

```bash
Copy code
terraform get
terraform init
terraform plan
terraform apply
```

### 주의 사항
AWS 키를 항상 기밀로 유지하세요. 특히 Git과 같은 버전 제어 시스템에 저장된 파일에 그것들을 하드코딩하지 마세요. 자격 증명을 관리하기 위해 환경 변수, AWS 구성 또는 다른 안전한 방법을 사용하는 것을 고려하세요.

더 자세한 질문이나 문제가 있으면 기술 팀에 문의하거나 공식 Terraform 및 AWS 문서를 참조하세요.
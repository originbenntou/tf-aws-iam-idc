terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.77.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "mototsuka8973_admin"  # プロファイルを直接指定
}

data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  # 既存の許可セットのARNをここに定義
  permission_sets = {
    "admin" = "arn:aws:sso:::permissionSet/ssoins-775857b8ea5b2579/ps-1bf507a4d793e9ca"
    "read_only" = "arn:aws:sso:::permissionSet/ssoins-775857b8ea5b2579/ps-73b8054ca1ce9c5d"
  }
}

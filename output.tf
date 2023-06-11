#----------------------------------------------------------
#  プロバイダ設定
#  プロバイダ：aws
#  リージョン：asia-northeast1
#  プロジェクトID(GCPの時のみ)：nttd-platformtec
#----------------------------------------------------------
provider "aws" {
  region   = "asia-northeast1"
}

#----------------------------------------------------------
#  VPC設定
#  VPC名：IA-fujitaerb-vm
#----------------------------------------------------------
resource "aws_vpc" "IA-fujitaerb-vm" {
  tags = {
    Name = "IA-fujitaerb-vm"
  }
}

#----------------------------------------------------------
#  サブネット設定
#  サブネット名：main
#  CIDR範囲：10.0.1.0/24
#----------------------------------------------------------
resource "aws_subnet" "main" {
  vpc_id   = aws_vpc.IA-fujitaerb-vm.id
  cidr_block   = "10.0.1.0/24"
  tags = {
    Name = "main"
  }
}


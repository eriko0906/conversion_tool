provider "aws" {
  region   = "asia-northeast1"
}

resource "aws_vpc" "IA-fujitaerb-vm" {
  tags = {
    Name = "IA-fujitaerb-vm"
  }
}

resource "aws_subnet" "main" {
  vpc_id   = aws_vpc.IA-fujitaerb-vm.id
  cidr_block   = "10.0.1.0/24"
  tags = {
    Name = "main"
  }
}


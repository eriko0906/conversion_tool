#----------------------------------------------------------
#  プロバイダ設定
#  プロバイダ：google
#  リージョン：asia-northeast1
#  プロジェクトID(GCPの時のみ)：nttd-platformtec
#----------------------------------------------------------
provider "google" {
  region   = "asia-northeast1"
  project = "nttd-platformtec"
}

#----------------------------------------------------------
#  VPC設定
#  VPC名：IA-fujitaerb-vm
#----------------------------------------------------------
resource "google_compute_network" "IA-fujitaerb-vm" {
  name   = "IA-fujitaerb-vm"
}

#----------------------------------------------------------
#  サブネット設定
#  サブネット名：main
#  CIDR範囲：10.0.1.0/24
#----------------------------------------------------------
resource "google_compute_subnetwork" "main" {
  name   = "main"
  network   = google_compute_network.IA-fujitaerb-vm.id
  ip_cidr_range   = "10.0.1.0/24"
}

#----------------------------------------------------------
#  VM設定
#  インスタンス名：ia-fujitaerb-vm
#  マシン・インスタンスタイプ：t2.micro
#  マシンイメージ・ami：ami-0f903fb156f24adbf
#----------------------------------------------------------
resource "google_compute_instance" "ia-fujitaerb-vm" {
  name   = "ia-fujitaerb-vm"
  machine_tyep   = "t2.micro"
  boot_disk {
    initialize_params {
      image = "ami-0f903fb156f24adbf"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.main.id
  }
}


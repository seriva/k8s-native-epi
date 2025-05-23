terraform {
  required_version = ">= 1.6.0"

  required_providers {
      k3d = {
        source  = "pvotal-tech/k3d"
        version = "0.0.7"
      }
      helm = {
        source = "hashicorp/helm"
        version = "2.16.1"
      }
      kubectl = {
        source  = "alekc/kubectl"
        version = "2.1.2"
      }
  }
}

provider "k3d" {
}

provider "helm" {
  kubernetes {
    config_path    = "${var.k3s_cluster.config_location}"
    config_context = "k3d-${k3d_cluster.epiphany_cluster.name}"
  }
}

provider "kubectl" {
  config_path    = "${var.k3s_cluster.config_location}"
  config_context = "k3d-${k3d_cluster.epiphany_cluster.name}"
}

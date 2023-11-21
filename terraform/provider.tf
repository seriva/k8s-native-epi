terraform {
  required_version = ">= 1.6.0"

  required_providers {
      k3d = {
        source  = "moio/k3d"
        version = "0.0.10"
      }
      helm = {
        source = "hashicorp/helm"
        version = "2.11.0"
      }
      kubectl = {
        source  = "alekc/kubectl"
        version = "2.0.3"
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

resource "k3d_cluster" "epiphany_cluster" {
    name    = "${var.k3s_cluster.name}"
    servers = var.k3s_cluster.servers
    agents  = var.k3s_cluster.agents

    kube_api {
        host_ip = "0.0.0.0"
        host_port = 6445
    }

    image   = "rancher/k3s:v${var.k3s_cluster.version}-k3s1"

    k3d {
        disable_load_balancer = false
        disable_image_volume  = false
    }

    kubeconfig {
        update_default_kubeconfig = true
        switch_current_context    = true
    }

    runtime {
        servers_memory = var.k3s_cluster.node_memory
        agents_memory  = var.k3s_cluster.node_memory
    }
}

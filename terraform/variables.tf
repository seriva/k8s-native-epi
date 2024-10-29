# K3s cluster configuration
variable "k3s_cluster" {
  description = "K3s cluster configuration"
  type = object({
    name            = string
    version         = string
    config_location = string
    servers         = number
    agents          = number
    node_memory     = string
  })
  default = {
    name            = "epiphany"
    version         = "1.31.1"
    config_location = "~/.kube/config"
    servers         = 1
    agents          = 4
    node_memory     = "4096m"
  }
}

# operator configuration
variable "operators" {
  description = "Operator configurations"
  type = list(object({
    enabled         = bool
    name            = string
    namespace       = string
    repository      = string
    chart           = string
    version         = string
    values_file     = string
    component_files = list(string)
    node_ports      = list(object({
      host_port      = number
      container_port = number
    }))
  }))
  default = [
    {
      enabled         = true
      name            = "monitoring-prometheus"
      repository      = "https://prometheus-community.github.io/helm-charts"
      chart           = "kube-prometheus-stack"
      namespace       = "observability"
      version         = "65.4.0"
      values_file     = "prometheus.yaml"
      component_files = [
        "observability/cnpg-prometheus-rules.yaml",
        "observability/cnpg-dashboard.yaml",
        "observability/kafka-prometheus-rules.yaml",
        "observability/kafka-resources-metrics.yaml",
        "observability/kafka-entity-operator-metrics.yaml",
        "observability/kafka-cluster-operator-metrics.yaml",
        "observability/kafka-dashboard.yaml",
        "observability/rabbitmq-service-monitor.yaml",
        //"observability/rabbitmq-prometheus-rules.yaml",
        "observability/rabbitmq-dashboard-overview.yaml"
      ],
      node_ports    = [
        # Grafana dashboard
        {
          host_port      = 9091
          container_port = 30001
        },
        # Prometheus dashboard
        {
          host_port      = 9092
          container_port = 30002
        }
      ]
    },
    {
      enabled         = true
      name            = "logging-loki"
      repository      = "https://grafana.github.io/helm-charts"
      chart           = "loki-stack"
      namespace       = "observability"
      version         = "2.10.2"
      values_file     = "loki.yaml"
      component_files = [
        "observability/loki-dashboard-monitoring.yaml",
        "observability/loki-dashboard-k8s-logs.yaml",
        "observability/loki-dashboard-apps-logs.yaml"
      ],
      node_ports    = []
    },
    {
      enabled         = true
      name            = "opensearch-operator"
      repository      = "https://opensearch-project.github.io/opensearch-k8s-operator/"
      chart           = "opensearch-operator"
      namespace       = "opensearch-operator"
      version         = "2.6.1"
      values_file     = "opensearch.yaml"
      component_files = [
        "opensearch/namespace.yaml",
        "opensearch/cluster.yaml",
        "opensearch/opensearch-dashboard-service.yaml"
      ],
      node_ports    = [
        # Opensearch dashboard
        {
          host_port      = 9093
          container_port = 30003
        }
      ]
    },
    {
      enabled         = true
      name            = "cnpg-operator"
      repository      = "https://cloudnative-pg.github.io/charts"
      chart           = "cloudnative-pg"
      namespace       = "cnpg-operator"
      version         = "0.22.1"
      values_file     = "cnpg.yaml"
      component_files = [
        "postgresql/namespace.yaml",
        "postgresql/secret.yaml",
        "postgresql/app-secret.yaml",
        "postgresql/cluster.yaml",
        "postgresql/pgadmin-secret.yaml",
        "postgresql/pgadmin-service.yaml",
        "postgresql/pgadmin-config.yaml",
        "postgresql/pgadmin.yaml"
      ],
      node_ports    = [
        # pgAdmin dashboard
        {
          host_port      = 9094
          container_port = 30004
        }
      ]
    },
    {
      enabled         =  true
      name            = "strimzi-operator"
      repository      = "https://strimzi.io/charts/"
      chart           = "strimzi-kafka-operator"
      namespace       = "kafka"
      version         = "0.43.0"
      values_file     = "strimzi.yaml"
      component_files = [
        "kafka/cluster.yaml",
        "kafka/metrics.yaml",
        "kafka/topic.yaml",
        "kafka/kafka-ui.yaml",
        "kafka/kafka-ui-service.yaml"
      ],
      node_ports    = [
        # Kafka UI dashboard
        {
          host_port      = 9095
          container_port = 30005
        }
      ]
    },
    {
      enabled         = true
      name            = "rabbitmq-operator"
      repository      = "https://charts.bitnami.com/bitnami"
      chart           = "rabbitmq-cluster-operator"
      namespace       = "rabbitmq-operator"
      version         = "4.3.25"
      values_file     = "rabbitmq.yaml"
      component_files = [
        "rabbitmq/namespace.yaml",
        "rabbitmq/cluster.yaml"
      ],
      node_ports    = []
    }
  ]
}

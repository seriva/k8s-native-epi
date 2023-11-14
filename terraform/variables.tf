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
    version         = "1.27.4"
    config_location = "~/.kube/config"
    servers         = 2
    agents          = 3
    node_memory     = "4096m"
  }
}

# operator configuration
variable "operators" {
  description = "Operator configuration"
  type = list(object({
    name        = string
    namespace   = string
    repository  = string
    chart       = string
    version     = string
    values_file = string
  }))
  default = [
    {
      name         = "monitoring-prometheus"
      repository   = "https://prometheus-community.github.io/helm-charts"
      chart        = "kube-prometheus-stack"
      namespace    = "observability"
      version      = "52.1.0"
      values_file  = "prometheus.yaml"
    },
    {
      name         = "logging-loki"
      repository   = "https://grafana.github.io/helm-charts"
      chart        = "loki-stack"
      namespace    = "observability"
      version      = "2.9.11"
      values_file  = "loki.yaml"
    },
    {
      name         = "opensearch-operator"
      repository   = "https://opster.github.io/opensearch-k8s-operator/"
      chart        = "opensearch-operator"
      namespace    = "opensearch-operator"
      version      = "2.4.0"
      values_file  = "opensearch.yaml"
    },
    {
      name         = "postgresql-operator"
      repository   = "https://cloudnative-pg.github.io/charts"
      chart        = "cloudnative-pg"
      namespace    = "postgresql-operator"
      version      = "0.19.1"
      values_file  = "postgresql.yaml"
    },
    {
      name         = "rabbitmq-operator"
      repository   = "https://charts.bitnami.com/bitnami"
      chart        = "rabbitmq-cluster-operator"
      namespace    = "rabbitmq-operator"
      version      = "3.1.0"
      values_file  = "rabbitmq.yaml"
    },
    {
      name         = "kafka-operator"
      repository   = "https://strimzi.io/charts/"
      chart        = "strimzi-kafka-operator"
      namespace    = "kafka-operator"
      version      = "0.38.0"
      values_file  = "kafka.yaml"
    }
  ]
}

# components manifests
variable "manifests" {
  description = "Component manifests"
  type = list
  default = [
    "opensearch-namespace.yaml",
    "opensearch-cluster.yaml",

    "postgresql-namespace.yaml",
    "postgresql-secret.yaml",
    "postgresql-app-secret.yaml",
    "postgresql-cluster.yaml",
    "postgresql-pgadmin-secret.yaml",
    "postgresql-pgadmin-service.yaml",
    "postgresql-pgadmin-config.yaml",
    "postgresql-pgadmin.yaml",

    "rabbitmq-namespace.yaml",
    "rabbitmq-cluster.yaml",

    //"kafka-namespace.yaml",
    //"kafka-cluster.yaml"
  ]
}

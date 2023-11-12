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
      name         = "prometheus-operator"
      repository   = "https://prometheus-community.github.io/helm-charts"
      chart        = "kube-prometheus-stack"
      namespace    = "prometheus-operator"
      version      = "52.1.0"
      values_file  = "prometheus.yaml"
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
      name         = "strimzi-operator"
      repository   = "https://strimzi.io/charts/"
      chart        = "strimzi-kafka-operator"
      namespace    = "strimzi-operator"
      version      = "0.38.0"
      values_file  = "strimzi.yaml"
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
      name         = "postgresql-operator"
      repository   = "https://cloudnative-pg.github.io/charts"
      chart        = "cloudnative-pg"
      namespace    = "postgresql-operator"
      version      = "0.19.1"
      values_file  = "postgresql.yaml"
    }
  ]
}


# components manifests
variable "manifests" {
  description = "Component manifests"
  type = list
  default = [
    "logging-namespace.yaml",
    "logging-opensearch.yaml"
  ]
}

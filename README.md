# k8s-native-epi

Project to create a K8s-native version of [Epiphany](https://github.com/hitachienergy/epiphany) using the [operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).

## Pre-requisites

- Terraform 1.6.3
- Docker

When running Rancher-Desktop run to make sure to set vm.max_map_count: https://docs.rancherdesktop.io/how-to-guides/increasing-open-file-limit/

## Operators

To replace the existing Epiphany components we are using operators. Operators give us the ability to easily create and configure the components using custom K8s CRDs.

| Epiphany Component  | Replacement Tools + Operator                                       |
| ------------------- | -------------------------------------------------------------------|
| Monitoring          | https://github.com/prometheus-operator/prometheus-operator         |
| Logging             | https://github.com/grafana/helm-charts/tree/main/charts/loki-stack |
| Kafka               | https://github.com/strimzi/strimzi-kafka-operator                  |
| RabbitMQ            | https://github.com/rabbitmq/cluster-operator                       |
| PostgreSQL          | https://github.com/cloudnative-pg/cloudnative-pg                   |
| Opensearch          | https://github.com/Opster/opensearch-k8s-operator                  |

### Monitoring and Logging

To access Grafana and Prometheus:

```shell
kubectl port-forward svc/monitoring-prometheus-grafana 8080:80 -n monitoring
kubectl port-forward svc/prometheus-operated 9090 -n monitoring
```

Loki datasource if missing: http://logging-loki.logging.svc.cluster.local:3100
Loki dashboard: 13639, 15141, 14055

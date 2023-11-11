# k8s-native-epi

Project to create a K8s-native version of [Epiphany](https://github.com/hitachienergy/epiphany) using the [operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).

## Prerequisites

When running Rancher-Desktop run to make sure to set vm.max_map_count: https://docs.rancherdesktop.io/how-to-guides/increasing-open-file-limit/

## Operators

To replace the existing Epiphany components we are using operators. Operators give us the ability to easily create and configure the components using custom K8s CRDs.

| Epiphany Component  | Replacement Operator                                       |
| ------------------- | -----------------------------------------------------------|
| Monitoring          | https://github.com/prometheus-operator/prometheus-operator |
| Logging             | https://github.com/Opster/opensearch-k8s-operator          |
| Kafka               | https://github.com/strimzi/strimzi-kafka-operator          |
| RabbitMQ            | https://github.com/rabbitmq/cluster-operator               |
| PostgreSQL          | https://github.com/CrunchyData/postgres-operator           |

### Monitoring

To access Grafana and Prometheus:

```shell
kubectl port-forward svc/prometheus-operator-grafana 8080:80 -n prometheus-operator
kubectl port-forward svc/prometheus-operated 9090 -n prometheus-operator
```

### Logging

To access the dashboard:

```shell
kubectl port-forward svc/logging-dashboards 5601 -n logging
```

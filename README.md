# k8s-native-epi

Sample project to create a K8s-native version of [Epiphany](https://github.com/hitachienergy/epiphany) using the [operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).

For now it focusses on a local stack using [K3s](https://k3s.io/) for K8s bootstrapped with [k3d](https://k3d.io/). However it can be easily modified to use other (managed) versions of K8s like AKS or EKS.

## Pre-requisites

- Terraform 1.6.3
- Docker, recommanded [Docker-Desktop](https://www.docker.com/products/docker-desktop/) or [Rancher-Desktop](https://rancherdesktop.io/)

For the opensearch component one needs to set the vm.max_map_count to 262144:

- On Rancher-Desktop follow [this](https://docs.rancherdesktop.io/how-to-guides/increasing-open-file-limit/)
- On Docker-Desktop add `kernelCommandLine = sysctl.vm.max_map_count=262144` to the `.wslconfig` config file.

## Components and Operators

To replace the existing Epiphany components we are using operators. Operators give us the ability to easily create and configure the Epiphany components using custom K8s [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) resources.

| Epiphany Component  | Replacement Tools + Operator                                       |
| ------------------- | -------------------------------------------------------------------|
| Monitoring          | https://github.com/prometheus-operator/prometheus-operator         |
| Logging             | https://github.com/grafana/helm-charts/tree/main/charts/loki-stack |
| Kafka               | https://github.com/strimzi/strimzi-kafka-operator                  |
| RabbitMQ            | https://github.com/rabbitmq/cluster-operator                       |
| PostgreSQL          | https://github.com/cloudnative-pg/cloudnative-pg                   |
| Opensearch          | https://github.com/Opster/opensearch-k8s-operator                  |

## Confguraitons

TODO

## Deployment

```shell
terraform init
terraform apply
```

## Monitoring and Logging

The solution uses the same Prometheus+Grafana+Alertmanager stack for monitoring as Epiphany, only now deployed as an K8s operator. To access Grafana and Prometheus:

```shell
kubectl port-forward svc/monitoring-prometheus-grafana 8080:80 -n monitoring
kubectl port-forward svc/prometheus-operated 9090 -n monitoring
```

For logging, the Epiphany Opensearch stack was swapped out for [Loki](https://grafana.com/oss/loki/) as this integrates nicely with Grafana giving us one place to view both logging and monitoring. Few notes:

- Loki datasource for Grafana if missing: http://logging-loki.logging.svc.cluster.local:3100
- Usefull Loki dashboard: 13639, 15141, 14055

## Opensearch

 To access Opensearch Dashboard and API:

```shell
kubectl port-forward svc/opensearch-dashboards 5601 -n opensearch
kubectl port-forward svc/opensearch 9200 -n opensearch
```

Use the following to check the clusters health:

```shell
curl --insecure -X GET "https://admin:admin@localhost:9200/_cluster/health?wait_for_status=yellow&timeout=50s&pretty"
```

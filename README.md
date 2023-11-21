# k8s-native-epi

Project to create a K8s-native version of [Epiphany](https://github.com/hitachienergy/epiphany) using the [operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) for local development.

Existing Epiphany components are replaced using the following operators listed below. Operators give the ability to easily create/configure/manage the Epiphany components using custom K8s [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) resources.

| Epiphany Component  | Operator                                                           |
| ------------------- | -------------------------------------------------------------------|
| Monitoring          | https://github.com/prometheus-operator/prometheus-operator         |
| Logging             | https://github.com/grafana/helm-charts/tree/main/charts/loki-stack |
| Opensearch          | https://github.com/Opster/opensearch-k8s-operator                  |
| PostgreSQL          | https://github.com/cloudnative-pg/cloudnative-pg                   |
| RabbitMQ            | https://github.com/rabbitmq/cluster-operator                       |
| Kafka               | https://github.com/strimzi/strimzi-kafka-operator                  |

For now it focusses on a local stack using [K3s](https://k3s.io/) for K8s bootstrapped with [k3d](https://k3d.io/). However it can be easily modified to use other (managed) versions of K8s like AKS or EKS.

The whole project uses [Terraform](https://www.terraform.io/) with several providers to bootstrap and deploy the environment.

## Prerequisites

-[Terraform](https://www.terraform.io/) 1.6.3+
- Docker, recommanded [Docker-Desktop](https://www.docker.com/products/docker-desktop/) or [Rancher-Desktop](https://rancherdesktop.io/)
- Laptop with at least 32gb of ram to deploy the entire stack

For the opensearch component one needs to set the vm.max_map_count to 262144:

- On Rancher-Desktop follow [this](https://docs.rancherdesktop.io/how-to-guides/increasing-open-file-limit/)
- On Docker-Desktop add `kernelCommandLine = sysctl.vm.max_map_count=262144` to the `.wslconfig` config file and restart.

## Confgurations and deployment

Configuration is done on 3 different levels.

1. `terraform/variables.tf` has 2 variable definitions with defaults which can be used for in a custom `tfvars` file and is the basis for the Terraform deployment orchistration:
    - `k3s_cluster`: describes the K3s cluster layout.
    - `operators`: A list of Helm charts that represent the operators that will be installed. It also contains the `component_files` list per operator which contains the K8s deployment files of the component using the [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) the operator provides.
2. `terraform/operators/*.yaml` contains the custom Helm configrations that can be applied the the operators. Every file contains a link to the full file of avalable configurations. Generally can be left as is.
3. `terraform/operators/*.*/*.yaml` contains the K8s deployments of the components. Use the above links in the table to the operator documentation to see how to configure each [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/).

To deploy the `k8s-native-epi` environment run the following commands:

```shell
cd terraform
terraform init
terraform apply
```

## Components

### Monitoring and Logging

The solution uses the same Prometheus+Grafana+Alertmanager stack for monitoring as Epiphany, only now deployed as an K8s operator. For logging, the Epiphany Opensearch stack was swapped out for [Loki](https://grafana.com/oss/loki/) as this integrates nicely with Grafana giving us one place to view both logging and monitoring. To access Grafana and Prometheus:

```shell
# User/PW: admin/kaasbal
kubectl port-forward svc/monitoring-prometheus-grafana 8080:80 -n observability
kubectl port-forward svc/prometheus-operated 9090 -n observability
```

Out of the box, metrics and rules for all components are integrated with Prometheus and several dashboards for K8s, node-exporter, logging, Postgresql, Kafka and RabbitMQ are included with Grafana for visualization.

### Opensearch

To access Opensearch Dashboard and Opensearch API:

```shell
# User/PW: admin/admin
kubectl port-forward svc/opensearch-dashboards 5601 -n opensearch
```

To expose the Opensearch API:

```shell
kubectl port-forward svc/opensearch 9200 -n opensearch
```

Use the following to check the clusters health:

```shell
curl --insecure -X GET "https://admin:admin@localhost:9200/_cluster/health?wait_for_status=yellow&timeout=50s&pretty"
```

### Postgress

To access pgAdmin management dashboard:

```shell
# User/PW: admin@admin.com/kaasbal
kubectl port-forward svc/pgadmin-service 8081:80 -n postgresql
```

Access to database server: `kaasbal`

### RabbitMQ

TODO

### Kafka

To access the Kafka-UI dashboard:

```shell
kubectl port-forward svc/kafka-ui-service 8082:8080 -n kafka
```

To run a consumer on the created `test-topic`:

```shell
kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server svc/kafka-kafka-bootstrap:9092 --topic test-topic --from-beginning
```

To run a producer on the created `test-topic`:

```shell
kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server svc/kafka-kafka-brokers:9092 --topic test-topic
```

Now you can add messages in the producer which should appear in the consumer. Alternatively you can also expose the broker service to publish messages to localhost:9092:

```shell
kubectl port-forward svc/kafka-kafka-bootstrap 9092 -n kafka
```

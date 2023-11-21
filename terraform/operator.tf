locals {
  enabled_operators = { for each in var.operators : each.name => each if each.enabled }
}

resource "helm_release" "operator" {
  for_each = local.enabled_operators

  name             = each.value.name
  repository       = each.value.repository
  chart            = each.value.chart
  namespace        = each.value.namespace
  version          = each.value.version
  create_namespace = true

  values = [
    file("${path.module}/configuration/${each.value.values_file}")
  ]

  depends_on       = [k3d_cluster.epiphany_cluster]
}
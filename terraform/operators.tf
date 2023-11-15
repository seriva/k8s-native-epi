resource "helm_release" "operators" {
  count            = length(var.operators)

  name             = var.operators[count.index].name
  repository       = var.operators[count.index].repository
  chart            = var.operators[count.index].chart
  namespace        = var.operators[count.index].namespace
  version          = var.operators[count.index].version
  create_namespace = true

  values = [
    file("${path.module}/operators/${var.operators[count.index].values_file}")
  ]

  depends_on       = [k3d_cluster.epiphany_cluster]
}
resource "kubectl_manifest" "components" {
  for_each = toset(var.manifests)

  yaml_body = templatefile("${path.module}/component/${each.value}", {})

  depends_on       = [helm_release.operators]
}
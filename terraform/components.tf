resource "kubectl_manifest" "components" {
  for_each = toset(var.manifests)

  yaml_body = file("${path.module}/components/${each.value}")

  depends_on       = [helm_release.operators]
}
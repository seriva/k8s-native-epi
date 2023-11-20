locals {
  component_paths = concat( [ for each in local.enabled_operators : each.components_files ] ...)
}

resource "kubectl_manifest" "components" {
  count    = length(local.component_paths)

  yaml_body = file("${path.module}/components/${local.component_paths[count.index]}")

  depends_on = [helm_release.operators]
}
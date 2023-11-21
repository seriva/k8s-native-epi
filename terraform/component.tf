locals {
  component_paths = concat( [ for each in local.enabled_operators : each.component_files ] ... )
}

resource "kubectl_manifest" "component" {
  for_each    = toset(local.component_paths)

  yaml_body = file("${path.module}/configuration/${each.value}")

  depends_on = [helm_release.operator]
}
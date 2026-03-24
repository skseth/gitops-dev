
data "kubernetes_namespace_v1" "apps" {
  metadata {
    name = "apps"
  }
}

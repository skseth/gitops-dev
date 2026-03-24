
# Use the 'kbst/kustomization' provider to build your manifests
data "kustomization_build" "example" {
  # Path to your Kustomize directory (base or overlay)
  path = "../../app-kustomize/aankalan/k8s/overlays/dev"
}

# Apply the generated manifests using the 'kustomization_resource'
resource "kustomization_resource" "example" {
  # Use for_each to manage each individual resource
  for_each = data.kustomization_build.example.ids
  manifest = data.kustomization_build.example.manifests[each.value]
}
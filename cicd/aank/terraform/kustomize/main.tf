terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.0.1" # Example, check the HashiCorp Registry for the latest
    }    
  }
}

provider "kustomization" {
  # one of kubeconfig_path, kubeconfig_raw or kubeconfig_incluster must be set

  kubeconfig_path = "~/.kube/config"
  # can also be set using KUBECONFIG_PATH environment variable

  # kubeconfig_raw = data.template_file.kubeconfig.rendered
  # kubeconfig_raw = yamlencode(local.kubeconfig)

  # kubeconfig_incluster = true
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

data "kubernetes_namespace_v1" "apps" {
  metadata {
    name = "apps"
  }
}

# Use the 'kbst/kustomization' provider to build your manifests
data "kustomization_build" "example" {
  # Path to your Kustomize directory (base or overlay)
  path = "../../app-kustomize/aank/k8s/overlays/dev"
}

# Apply the generated manifests using the 'kustomization_resource'
resource "kustomization_resource" "example" {
  # Use for_each to manage each individual resource
  for_each = data.kustomization_build.example.ids
  manifest = data.kustomization_build.example.manifests[each.value]
}

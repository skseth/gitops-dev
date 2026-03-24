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


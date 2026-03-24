terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.15.1"
    }    
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.0.1" # Example, check the HashiCorp Registry for the latest
    }    
    mysql = {
      source  = "petoju/mysql"
      version = "3.0.72"
    }
    minio = {
      source  = "aminueza/minio"
      version = "3.28.1"
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


provider "mysql" {
  endpoint = "127.0.0.1:3306"
  username = "root"
  password = "strong_password" # in practice we set environment variables, never include password 
}

provider "minio" {
  // required
  minio_server   = "127.0.0.1:9002"
  minio_user     = "minioadmin"
  minio_password = "minioadmin" # use env vars
}

provider "argocd" {
  server_addr = "localhost:8080"
  username    = "admin"
  password    = "password"
  insecure = true
}    

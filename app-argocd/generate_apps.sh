#!/usr/bin/env bash

# This script generates ArgoCD application manifests for the Spring Boot application.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_KUSTOMIZE_ROOT_DIR=$(realpath "$SCRIPT_DIR/../app-kustomize")
REPO_URL="https://github.com/skseth/gitops-dev.git"
ARGOCD_NAMESPACE="argocd"
ENV=base

error() {
	echo "Error: $1" >&2
	exit 1
}

list_kustomize_dirs() {
	local dir="$1"
	find "$dir" -type f -name "kustomization.yaml" -exec dirname {} \; || error "Failed to list directories in $dir"
}


create_child_app_yaml() {
	local kustomize_dir="$1"

	local env=$(basename "$kustomize_dir")
	local overlays_dir=$(dirname "$kustomize_dir")
	local app_dir=$(dirname "$overlays_dir")
	local app_name=$(basename "$app_dir")
	local app_of_app_dir=$(dirname "$app_dir")
	local app_of_app_name=$(basename "$app_of_app_dir")
	
	local target_dir="$SCRIPT_DIR/$env/$app_of_app_name"
	local target_file="$target_dir/$app_name.yaml"
	local app_of_app_file="$SCRIPT_DIR/$env/$app_of_app_name.yaml"

	mkdir -p "$target_dir" || error "Failed to create directory $target_dir"
	rm -f "$target_file" > /dev/null 2>&1
	cat > "$target_file" <<-EOF
	apiVersion: argoproj.io/v1alpha1
	kind: Application
	metadata:
	  name: $app_name
	  namespace: $ARGOCD_NAMESPACE
	spec:
	  project: default
	  source:
	    repoURL: '$REPO_URL'
	    targetRevision: HEAD
	    path: app-kustomize/$app_of_app_name/$app_name/$env
	  destination:
	    server: https://kubernetes.default.svc
	    namespace: apps
	  syncPolicy:
	    automated:
	      prune: true
	      selfHeal: true
	    syncOptions:
	      - CreateNamespace=true 
	EOF

	if [[ -f "$app_of_app_file" ]]; then
		return
	fi

	cat > "$app_of_app_file" <<-EOF
	apiVersion: argoproj.io/v1alpha1
	kind: Application
	metadata:
	  name: ${app_of_app_name}
	  namespace: ${ARGOCD_NAMESPACE}
	  finalizers:
	    - resources-finalizer.argocd.argoproj.io # Ensures children are deleted
	spec:
	  project: default
	  source:
	    repoURL: '${REPO_URL}'
	    targetRevision: HEAD
	    path: app-argocd/${env}/${app_of_app_name}
	  destination:
	    server: 'https://kubernetes.default.svc'
	    namespace: ${ARGOCD_NAMESPACE}
	  syncPolicy:
	    automated:
	      prune: true
	      selfHeal: true
	EOF


}

kustomize_dirs=$(list_kustomize_dirs "$APP_KUSTOMIZE_ROOT_DIR")
for dir in $kustomize_dirs; do
	create_child_app_yaml "$dir"
done



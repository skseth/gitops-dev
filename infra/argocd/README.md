# Kubectl files 

start: skaffold run
stop: skaffold delete

expose: kubectl port-forward svc/argocd-server -n argocd 8080:443

Follow: https://argo-cd.readthedocs.io/en/stable/getting_started/

argocd admin initial-password -n argocd
argocd --insecure login localhost:8080
argocd account update-password

kubectl create namespace guestbook

argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace guestbook

argocd app get guestbook
argocd app sync guestbook

argocd repo add 

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


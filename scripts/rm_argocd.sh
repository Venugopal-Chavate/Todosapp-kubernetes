kubectl -n argocd delete -f ./argocd_manifests/argocd_install.yaml
kubectl delete -f ./argocd_manifests/argo_namespace.yaml


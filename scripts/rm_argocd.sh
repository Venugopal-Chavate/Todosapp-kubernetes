kubectl delete -f ./argocd_manifests/argocd_service_config.yaml
kubectl delete -n argocd -f ./argocd_manifests/argocd_install.yaml
kubectl delete -f ./argocd_manifests/argo_namespace.yaml


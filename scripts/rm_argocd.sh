kubectl delete -f ./agrocd_manifests/argocd_service_config.yaml
kubectl delete -n argocd -f ./agrocd_manifests/argocd_install.yaml
kubectl delete -f ./agrocd_manifests/argo_namespace.yaml


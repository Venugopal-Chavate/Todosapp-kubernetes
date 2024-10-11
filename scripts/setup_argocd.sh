kubectl apply -f ./agrocd_manifests/argo_namespace.yaml
kubectl apply -n argocd -f ./agrocd_manifests/argocd_install.yaml
sleep 10
echo "your argocd password is:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "Use the below command to get external ip of the argoCD interface, use it in browser with username as admin"
echo "
######################################################
Note: kubectl -n argocd get svc argocd-server"

echo "


Install argoCD cli 
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64"

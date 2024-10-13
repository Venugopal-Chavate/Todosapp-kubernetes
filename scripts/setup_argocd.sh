kubectl apply -f ./argocd_manifests/argo_namespace.yaml
kubectl -n argocd apply -f ./argocd_manifests/argocd_install.yaml
sleep 20
echo "
Install argoCD cli 
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

"
echo "your argocd password is:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "Access the argoCD interface with username as admin at below ip:"
sleep 30
kubectl -n argocd get svc argocd-server | awk '/argocd-server/{print $4}'




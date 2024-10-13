helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana
sleep 30
kubectl patch svc grafana -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc prometheus-server -p '{"spec": {"type": "LoadBalancer"}}'
sleep 40
kubectl get svc grafana | awk '/grafana/{print $4}'
kubectl get svc prometheus-server | awk '/prometheus-server/{print $4}'
#kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
#
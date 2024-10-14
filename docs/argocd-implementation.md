# ArgoCD Implementation

This document describes the setup and usage of ArgoCD in our project for continuous deployment.

## Overview

ArgoCD is used to manage and synchronize our Kubernetes manifests from the Git repository to the GKE cluster. It's deployed in the `argocd` namespace and configured to watch for changes in our GitHub repository.

## Installation

ArgoCD is installed using Kubernetes manifests located in the `argocd/manifests` directory.

1. install:
   ```
   ./scripts/setup_argocd.sh 
   ```
   This generates argocd loadbalancer url and the password to login. 
   Install ArgoCD CLI:
   ```
   Install argoCD cli 
   curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
   sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
   rm argocd-linux-amd64
   ```  
   Update your password using the command:
   ```
   argoCD account update-password
   ``` 
   refer [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_account_update-password/) for more details.

2. Verify the installation:
   ```
   kubectl get pods -n argocd
   ```

## Configuration

### Application Setup

ArgoCD is configured to watch our GitHub repository and sync changes to the Kubernetes cluster.
refer the below document for the configuration:
```
./argocd_manifests/CD.yaml
```
Applt the manifest using the kubectl command
```
kubectl -f create -f ./argocd_manifests/CD.yaml
```

This configuration tells ArgoCD to:
- Watch the `kubernetes` directory in your GitHub repository
- Deploy resources to the `default` namespace
- Automatically sync changes and prune removed resources

## Usage

### Accessing ArgoCD UI

1. The Loadbalancer URl is generated when you run the installation script in the earlier process, incase you need to refer the IP again:
1. Get the ArgoCD server URL:
   ```
   kubectl get svc argocd-server -n argocd # the external ip is the one to be used

   #or use

   kubectl -n argocd get svc argocd-server | awk '/argocd-server/{print $4}'
   ```

2. If you do not want to use the load balancer and want to Port forward the ArgoCD API server, then patch the argocd-service to be ClusterIP. Follow the below:
   ```
   kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "ClusterIP"}}'
   kubectl -n argocd port-forward svc/argocd-server -n argocd 8080:443
   ```

3. Access the UI at `https://localhost:8080`

### Syncing Applications

ArgoCD will automatically sync changes when they're pushed to the GitHub repository. You can also manually sync:

1. From the CLI:
   ```
   argocd app sync your-app
   ```

2. From the UI:
   - Navigate to your application
   - Click the "Sync" button

## Integration with CI/CD

Our GitHub Actions workflow is configured to update Kubernetes from "./manifests" in the repository. When changes are pushed:

1. The CI pipeline builds new frontend and backend images
2. New image versions are pushed to the GCP Artifact Registry
3. Kubernetes manifests are updated with new image versions
4. Changes are committed and pushed to the repository
5. ArgoCD detects the changes and syncs them to the cluster


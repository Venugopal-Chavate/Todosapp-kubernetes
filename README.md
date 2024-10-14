# Intended Goal

This project sets up:
    - A Google Kubernetes Engine (GKE) cluster in 2 availability zones using terraform with all the required components.
    - A CI pipeline using GitHub Actions
    - ArgoCD for continuous deployment 
    - Monitoring with Prometheus and Grafana
    - Secret management using Google Cloud Secret Manager
    - External Secrets Operator.
    ![alt text](./docs/images/image.png)

## Quick Setup

1. Clone this repository:
   ```
   git clone https://github.com/Venugopal-Chavate/myassignment.git
   cd myassignment
   ```

2. Set up Google Cloud credentials:
   ```
   gcloud auth login --no-launch-browser #this is one way
   ```

3. Create terraform.tfvars (or .tfvars.json or env.auto.tfvars and verify that your .gitignore includes that file)
   update the below values in the same:
   ```
    region = ""
    project_number = ""
    project_id = ""
    password = ""
    username = ""
    uri = "mongodb://yourusername:yourpassword@mongo-service:27017/todos?authSource=admin"
    zone = ""    #your first zone
    zone_2 = ""   ##your second zone
    cluster_name = ""
    location = ""
   ``` 
4. Make sure terraform IAM user has the following roles"
   ```
    roles/storage.admin
    roles/compute.admin
    roles/resourcemanager.projectIamAdmin
    roles/container.admin
    roles/secretmanager.admin
    roles/iam.serviceAccountAdmin
    roles/iam.workloadIdentityPoolAdmin
    roles/iam.serviceAccountKeyAdmin
   ``` 
5. Initialize Terraform:
   ```
   terraform init -migrate-state #this will sync up your local and remote state storage
   ```

6. Plan Terraform configuration:
   ```
   terraform plan
   ```
7. Apply Terraform configuration:
   ```
   terraform apply #Note: Infra-creation will occure in default VPC, if you dont want this edit terraform scripts accordingly
   ```

8. Verify and confirm your secrets are available in the secrets manager and create their first versions.

9. Configure kubectl to connect to your new cluster:
   ```
   gcloud container clusters get-credentials your-cluster-name --zone your-zone --project your-project-id
   ```

10. Setup ArgoCD using the below acript and get the login creds from the script outpus:
   ```
   ./scripts/setup_argocd.sh 
   ```

11. Create ArgoCD workload:
   ```
   kubectl apply -f ./argocd_manifests/CD.yaml #adjust to your needs update targets then apply. verify your deployment in GCP
   ```
12. Deploy External secrets operator, prometheus and grafana.
    ```
    ./Secretsoperator_prometheus_grafana/deploy.sh
    ```
13. Uncomment this section of ./terraform/main.tf 

      ![alt text](./docs/images/terrasnippet2.png)

   to

      ![alt text](./docs/images/terrasnippet1.png)


14. Apply Terraform configuration:
   ```
   terraform apply #Note: creates iam policy for gke service readonly to read secrets from secrets manager
   ```
15. login to grafana and create dashboard. Use the json file below to create a dashboard for grafana.
   ```
   ./Secretsoperator_prometheus_grafana/Grafana_Dashboard/grafana_hpa_observability.json
   ```
   paste the above while creating the grafana dashboard.

16. Set up GitHub Actions:
   - Go to your GitHub repository settings
   - Add necessary secrets for GCP authentication and artifact repository access
   - create a code secret for Actions called "SA" the value is your service account
   - create a code secret for Actions called "WIP" the value is your WorkLoadIdentityProvider(check out https://cloud.google.com/iam/docs/manage-workload-identity-pools-providers tosetup your workload identity provider)

14. 
## Development Setup

1. Install necessary tools:
   - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
   - [Helm](https://helm.sh/docs/intro/install/)

2. Set up your development environment:
   ```
   gcloud config set project your-project-id
   gcloud auth application-default login
   ```

3. For the application, we refrenced the below todos app:
   - [Todos](https://github.com/knaopel/docker-frontend-backend-db/tree/master)
   - The app had simple docker-compose.yaml based build with frontend, backend and db.
   - Certain modifications had to be made in the app, in order to use the app with k8s [like updating the db urls].

## Project Structure

- `/terraform`: Contains all Terraform configurations
- `/manifests`: Contains Kubernetes manifests
- `/argocd_manifests`: Contains ArgoCD configurations
- `/.github/workflows`: Contains CI pipeline configurations (GitHub Actions)
- `/Secretsoperator_prometheus_rgafana`: Contains External operator, Prometheus and Grafana configurations
- `/docs`: Detailed documentation for each component
- `/scripts`: Contains automation supports

## Further Documentation

For more detailed information about each component of this project, please refer to the following documentation:

- [Terraform Implementation](docs/terraform-implementation.md)
- [ArgoCD Implementation](docs/argocd-implementation.md)
- [Kubernetes Implementation](docs/kubernetes-implementation.md)
- [Prometheus and Grafana Setup](docs/prometheus-grafana.md)
- [Logging](docs/logging.md)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
# Intended Goal

This project sets up:
    - A Google Kubernetes Engine (GKE) cluster in 2 availability zones using terraform with all the required components.
    - A CI pipeline using GitHub Actions
    - ArgoCD for continuous deployment 
    - Monitoring with Prometheus and Grafana
    - Secret management using Google Cloud Secret Manager
    - External Secrets Operator.
    ![alt text](./docs/images/image.png)

### Note 1: 
Ideally I would seperate and maintain the contents of the ./manifests, ./terraform and application in different repositories to have better control of the components. But my intention here was to create a singular deployable repo. 
### Note 2:
The Terraform infrastructure will be created in a default VPC. please modify your terraform scripts accordingly by creating seperate VPC, Subnets and Gateways if you want to deploy in a seperate VPC.

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
    password = "password"
    username = "username"
    uri = "mongodb://mongo-service:27017/todos"
    # For a quick setup
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
   terraform init
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

10. Setup ArgoCD using the below script and get the login creds from the script outpus:
   ```
   ./scripts/setup_argocd.sh 
   ```

11. Deploy External secrets operator, prometheus and grafana.
    ```
    ./secretsoperator_prometheus_grafana/deploy.sh
    ```
12. Uncomment this section of ./terraform/main.tf 

   ![alt text](./docs/images/terrasnippet2.png)

   to
      
   ![alt text](./docs/images/terrasnippet1.png)

13. Apply Terraform configuration:
   ```
   cd ./terraform
   terraform init -migrate-state #this will sync up your local and remote state storage
   terraform apply #Note: creates iam policy for gke service readonly to read secrets from secrets manager
   cd ..
   ```

14. Create ArgoCD workload:
   ```
   kubectl apply -f ./argocd_manifests/CD.yaml #adjust to your needs update targets then apply. verify your deployment in GCP
   ```

15. login to grafana and create dashboard. Use the json file below to create a dashboard for grafana.
   ```
   ./secretsoperator_prometheus_grafana/Grafana_Dashboard/grafana_hpa_observability.json
   ```
   paste the above while creating the grafana dashboard.

16. Set up GitHub Actions:
   - Go to your GitHub repository settings
   - Add necessary secrets for GCP authentication and artifact repository access
   - create a code secret for Actions called "SA" the value is your service account
   - create a code secret for Actions called "WIP" the value is your WorkLoadIdentityProvider(check out https://cloud.google.com/iam/docs/manage-workload-identity-pools-providers tosetup your workload identity provider)


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
   - [Todos](https://github.com/Fabioh/todo-app)
   - The app had simple docker-compose.yaml based build with frontend, backend and db.
   - Certain modifications had to be made in the app, in order to use the app with k8s [like updating the db urls].

## Project Structure

- `/terraform`: Contains all Terraform configurations
- `/manifests`: Contains Kubernetes manifests
- `/argocd_manifests`: Contains ArgoCD configurations
- `/.github/workflows`: Contains CI pipeline configurations (GitHub Actions)
- `/secretsoperator_prometheus_rgafana`: Contains External operator, Prometheus and Grafana configurations
- `/docs`: Detailed documentation for each component
- `/scripts`: Contains automation supports

## Further Documentation

For more detailed information about each component of this project, please refer to the following documentation:

- [Terraform Implementation](docs/terraform-implementation.md)
- [ArgoCD Implementation](docs/argocd-implementation.md)
- [Kubernetes Implementation](docs/kubernetes-implementation.md)
- [Enternal Secrets Operator, Prometheus and Grafana Setup](docs/External_secretsoperator-prometheus-grafana.md)
- [Logging](docs/logging.md)

## Possible improvements

- Implement health checks for your applications
- Use kustomize or helm for managing environment-specific configurations
- Regularly audit and rotate ArgoCD credentials
- I also intend to update this with fluentd based logging to have a first level filter.
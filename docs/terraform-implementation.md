# Terraform Implementation

This document outlines the Terraform configuration used in our project to set up the Google Cloud Platform (GCP) infrastructure.
Provider version -> 6.0
Terraform version -> Terraform v1.9.7 on linux_amd64

## Overview

Our Terraform configuration performs the following tasks:
1. Creates a Google Cloud Storage bucket for storing Terraform state
2. Sets up a Google Kubernetes Engine (GKE) cluster with the below features:
    a. Cluster availability: 2 availability zones
    b. workload_identity_config - enabled
    c. A cluster autosccalar with the profile "OPTIMIZE_UTILIZATION 
    d. Default Logging Enabled.
    e. network_policy_config
    f. horizontal_pod_autoscaling
    g. http_load_balancing
3. Creates secret manager secrets. How ever the value or version of the same is to be updated manually as a best practice.
4. Configures necessary permissions for Kubernetes Service Account

## Prerequisites

- Terraform installed (version v1.9.7 or later)
- Google Cloud SDK installed and configured
- Appropriate GCP permissions to create resources

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Plan the changes:
   ```
   terraform plan
   ```

3. Apply the changes:
   ```
   terraform apply
   ```
4. Once the changes are applied for the first time
   ```
   terraform init -migrate-state #sync up cloud bucket and local state files.
   ```
Note: To destroy the infrastructure:
   ```
   terraform destroy
   ```

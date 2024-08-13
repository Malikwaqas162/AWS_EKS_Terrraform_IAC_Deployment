# AWS EKS Terraform IAC Deployment

Welcome to the AWS EKS Terraform IAC Deployment repository! This project provides a comprehensive infrastructure-as-code (IAC) solution for deploying an Amazon Elastic Kubernetes Service (EKS) cluster using Terraform, along with Kubernetes manifests for managing applications on the EKS cluster.

## Table of Contents
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Creating the EKS Cluster](#creating-the-eks-cluster)
  - [Deploying Kubernetes Infrastructure](#deploying-kubernetes-infrastructure)
    - [Option A: Using Terraform](#option-a-using-terraform)
    - [Option B: Using YAML Manifests](#option-b-using-yaml-manifests)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)

## Overview
This project demonstrates the deployment of an EKS cluster on AWS using Terraform and provides Kubernetes manifests to deploy and manage applications on the EKS cluster. The repository is organized into two main folders: `create_cluster` for setting up the EKS cluster and `eks_manifest` for deploying and managing Kubernetes resources.

## Project Structure

```plaintext
AWS_EKS_Terrraform_IAC_Deployment/
│
├── create_cluster/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
│
└── eks_manifest/
    ├── K8s_manifest_terraform/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── ...
    │
    └── K8s_manifest_yaml/
        ├── deployment.yaml
        ├── service.yaml
        ├── hpa.yaml
        └── ...
### Folder Structure

- **`create_cluster/`**: Contains the Terraform code to create the EKS cluster, VPC, security groups, IAM roles, and other required AWS resources.
- **`eks_manifest/K8s_manifest_terraform/`**: Contains the Terraform code to deploy and manage Kubernetes infrastructure within the EKS cluster.
- **`eks_manifest/K8s_manifest_yaml/`**: Contains YAML manifests for deploying and managing Kubernetes applications, services, and other resources.

### Prerequisites

To use this repository, ensure you have the following:

- Terraform installed on your local machine.
- An AWS account with the necessary permissions to create EKS resources.
- AWS CLI configured with your credentials.
- Basic knowledge of Terraform and Kubernetes.

### Usage

#### 1. Creating the EKS Cluster

1. Navigate to the `create_cluster` folder:

    ```bash
    cd create_cluster
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Apply the Terraform configuration to create the EKS cluster:

    ```bash
    terraform apply
    ```

4. Save the output for the Kubernetes configuration (`config_path`) for use in the next step.

#### 2. Deploying Kubernetes Infrastructure

You have two options for deploying and managing Kubernetes resources:

##### Option A: Using Terraform

1. Navigate to the `eks_manifest/K8s_manifest_terraform/` folder:

    ```bash
    cd ../eks_manifest/K8s_manifest_terraform
    ```

2. Update the `variables.tf` file with the `config_path` from the previous step.

3. Initialize Terraform:

    ```bash
    terraform init
    ```

4. Apply the Terraform configuration to deploy the Kubernetes infrastructure:

    ```bash
    terraform apply
    ```

##### Option B: Using YAML Manifests

1. Navigate to the `eks_manifest/K8s_manifest_yaml/` folder:

    ```bash
    cd ../eks_manifest/K8s_manifest_yaml
    ```

2. Apply the Kubernetes manifests to the EKS cluster:

    ```bash
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    kubectl apply -f hpa.yaml
    ```

### Customization

You can customize this deployment by modifying the `variables.tf` files in the `create_cluster` and `K8s_manifest_terraform/` folders, or by editing the YAML manifests in the `K8s_manifest_yaml/` folder.

### Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

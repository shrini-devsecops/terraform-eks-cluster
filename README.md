# Terraform EKS Cluster Setup

This repository contains Terraform configurations to provision an Amazon EKS cluster on AWS with:

* Custom VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* EKS Control Plane
* Managed Node Groups
* IAM Roles
* IAM Roles for Service Accounts (IRSA)
* Cluster Autoscaler

The implementation is based on the following guide:

* [Step-by-Step Guide: Creating an EKS Cluster with Terraform Resources, IAM Roles for Service Accounts, and EKS Cluster Autoscaler](https://medium.com/@tech_18484/step-by-step-guide-creating-an-eks-cluster-with-terraform-resources-iam-roles-for-service-df1c5e389811?utm_source=chatgpt.com)

---

# Architecture

```text
AWS Cloud
│
├── VPC
│   ├── Public Subnets
│   ├── Private Subnets
│   ├── Internet Gateway
│   └── NAT Gateway
│
├── Amazon EKS
│   ├── Control Plane
│   └── Managed Node Group
│
├── IAM Roles
│   ├── EKS Cluster Role
│   ├── Node Group Role
│   └── IRSA Role
│
└── Kubernetes Addons
    └── Cluster Autoscaler
```

---

# Prerequisites

Before starting, ensure you have:

* AWS Account
* AWS CLI configured
* Terraform installed
* kubectl installed
* IAM permissions to create EKS resources

---

# Tools Used

| Tool               | Purpose                     |
| ------------------ | --------------------------- |
| Terraform          | Infrastructure as Code      |
| AWS EKS            | Managed Kubernetes          |
| kubectl            | Kubernetes management       |
| IAM                | AWS access management       |
| Cluster Autoscaler | Kubernetes node autoscaling |

---

# Terraform File Structure

```text
.
├── 0-provider.tf
├── 1-vpc.tf
├── 2-igw.tf
├── 3-subnets.tf
├── 4-nat.tf
├── 5-routes.tf
├── 6-eks.tf
├── 7-nodes.tf
├── 8-iam-oidc.tf
├── 9-iam-autoscaler.tf
└── cluster-autoscaler.yaml
```

---

# Infrastructure Components

## 1. AWS Provider

Configures AWS provider and region.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

## 2. VPC Creation

Creates a dedicated VPC for EKS.

Features:

* CIDR block: `192.168.0.0/16`
* Separate networking for Kubernetes
* Public and private subnet architecture

---

## 3. Public and Private Subnets

Creates:

* 2 Public Subnets
* 2 Private Subnets
* Multi-AZ deployment

Subnet tags enable Kubernetes load balancer discovery.

### Public Subnet Tags

```hcl
"kubernetes.io/role/elb" = "1"
```

### Private Subnet Tags

```hcl
"kubernetes.io/role/internal-elb" = "1"
```

---

## 4. Internet Gateway

Provides internet connectivity for public resources.

---

## 5. NAT Gateway

Allows private subnet instances to access the internet securely.

Used for:

* Pulling Docker images
* Accessing package repositories
* Kubernetes node outbound traffic

---

## 6. Route Tables

Configures:

* Public route table via Internet Gateway
* Private route table via NAT Gateway

---

## 7. EKS Cluster

Creates an Amazon EKS cluster using Terraform.

Features:

* Managed Kubernetes control plane
* Multi-subnet configuration
* IAM role integration
* AWS managed cluster policies

---

## 8. Managed Node Group

Creates worker nodes for the EKS cluster.

Configuration:

* Private subnets
* On-demand instances
* Auto scaling configuration
* Kubernetes labels support

Example:

```hcl
instance_types = ["t2.medium"]
```

---

## 9. IAM Roles for Service Accounts (IRSA)

Implements OpenID Connect provider for Kubernetes service accounts.

Benefits:

* Least privilege access
* Fine-grained AWS permissions
* Secure pod-to-AWS access

---

## 10. Cluster Autoscaler

Deploys Kubernetes Cluster Autoscaler.

Features:

* Automatic node scaling
* AWS Auto Scaling Group integration
* Dynamic workload scaling

Deployment includes:

* Service Account
* RBAC permissions
* Deployment manifest
* IRSA integration

---

# Deployment Steps

## Step 1: Initialize Terraform

```bash
terraform init
```

---

## Step 2: Validate Terraform

```bash
terraform validate
```

---

## Step 3: Plan Infrastructure

```bash
terraform plan
```

---

## Step 4: Apply Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

---

# Configure kubectl

Update kubeconfig:

```bash
aws eks --region us-east-1 update-kubeconfig --name demo
```

Verify cluster:

```bash
kubectl get nodes
```

---

# Deploy Cluster Autoscaler

Apply autoscaler manifest:

```bash
kubectl apply -f cluster-autoscaler.yaml
```

Verify:

```bash
kubectl get pods -n kube-system
```

---

# Verification Commands

## Check Nodes

```bash
kubectl get nodes
```

## Check Pods

```bash
kubectl get pods -A
```

## Check Services

```bash
kubectl get svc
```

## Check EKS Cluster

```bash
aws eks list-clusters
```

---

# Cleanup

Destroy infrastructure:

```bash
terraform destroy
```

---

# Future Improvements

* Add Helm deployments
* Integrate Argo CD
* Add GitLab CI/CD
* Integrate Trivy scanning
* Add Checkov security scanning
* Enable Cluster Autoscaler via Helm
* Configure ALB Ingress Controller
* Add Prometheus and Grafana

---

# DevSecOps Enhancements

This setup can be extended with:

| Tool       | Purpose                |
| ---------- | ---------------------- |
| GitLab CI  | CI/CD Pipeline         |
| Argo CD    | GitOps Deployment      |
| Trivy      | Vulnerability Scanning |
| Checkov    | IaC Security           |
| Prometheus | Monitoring             |
| Grafana    | Visualization          |

---

# Learning Outcomes

This project demonstrates:

* Terraform Infrastructure as Code
* AWS Networking
* Amazon EKS Setup
* Kubernetes Networking
* IAM and IRSA
* Cluster Autoscaling
* DevOps and Cloud Automation

---

# References

* AWS EKS Documentation
* Terraform AWS Provider Documentation
* Kubernetes Documentation
* Medium tutorial referenced above

---

# Author

Shrini DevSecOps

GitHub: [https://github.com/shrini-devsecops](https://github.com/shrini-devsecops)

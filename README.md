# demo_project

Unified demo workspace for application services, Kubernetes delivery pipelines, and AWS infrastructure provisioning.

## Overview

This repository contains three primary parts:

1. Application code (Spring Boot microservices)
2. CI/CD pipeline assets for Kubernetes deployments
3. Terragrunt/Terraform infrastructure-as-code for AWS

## Repository Structure

```text
demo_project/
├── demo-app-code/
├── k8s-pipeline/
├── terragrunt-aws/
└── README.md
```

## Components

### 1) Application Services

Path: [demo-app-code](demo-app-code)

Contains the demo e-commerce microservices and build tooling.

- Tech stack: Spring Boot, Maven, JDK 8
- Services: api-gateway, user-service, product-service, order-service, payment-service
- Local build and image build helpers are documented in:
  [demo-app-code/README.md](demo-app-code/README.md)

Quick build:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
mvn clean package
```

### 2) Kubernetes Pipeline

Path: [k8s-pipeline](k8s-pipeline)

Contains Jenkins pipelines and shell scripts to build, push, and deploy the app services.

- Non-prod pipeline: [k8s-pipeline/Jenkinsfile](k8s-pipeline/Jenkinsfile)
- Stage/prod pipeline: [k8s-pipeline/Jenkinsfile-stage-prod](k8s-pipeline/Jenkinsfile-stage-prod)
- Deployment/chart assets: [k8s-pipeline/demo-app-helm](k8s-pipeline/demo-app-helm)
- Full usage guide: [k8s-pipeline/README.md](k8s-pipeline/README.md)

### 3) AWS Infrastructure (Terragrunt)

Path: [terragrunt-aws](terragrunt-aws)

Contains reusable Terraform modules and Terragrunt stacks for:

- network
- eks
- load-balancer
- rds-mysql
- redis

Includes:

- pipeline definitions under [terragrunt-aws/pipelines](terragrunt-aws/pipelines)
- deploy scripts under [terragrunt-aws/pipelines/scripts](terragrunt-aws/pipelines/scripts)
- environment stacks under [terragrunt-aws/terragrunt](terragrunt-aws/terragrunt)

Start here for infra setup and run instructions:
[terragrunt-aws/README.md](terragrunt-aws/README.md)

## Application Design Diagram

```mermaid
flowchart LR
    Client[Client / Browser] --> APIGW[api-gateway :8080]
    APIGW --> USER[user-service :9002]
    APIGW --> PRODUCT[product-service :9003]
    APIGW --> ORDER[order-service :9006]
    APIGW --> PAYMENT[payment-service :9007]
    ORDER --> PAYMENT
    ORDER --> PRODUCT
    ORDER --> USER
```

## Infrastructure Design Diagram

```mermaid
flowchart TB
    subgraph AWS_us_east_1[us-east-1]
      VPC1[VPC / Subnets]
      EKS1[EKS Cluster]
      ALB1[Application Load Balancer]
      RDS1[RDS MySQL]
      REDIS1[ElastiCache Redis]
      VPC1 --> EKS1
      VPC1 --> ALB1
      VPC1 --> RDS1
      VPC1 --> REDIS1
      ALB1 --> EKS1
      EKS1 --> RDS1
      EKS1 --> REDIS1
    end

    subgraph AWS_us_west_2[us-west-2 for perf/staging/prod]
      VPC2[VPC / Subnets]
      EKS2[EKS Cluster]
      ALB2[Application Load Balancer]
      RDS2[RDS MySQL]
      REDIS2[ElastiCache Redis]
      VPC2 --> EKS2
      VPC2 --> ALB2
      VPC2 --> RDS2
      VPC2 --> REDIS2
    end

    TG[Terragrunt Stacks] --> AWS_us_east_1
    TG --> AWS_us_west_2
    TFCloud[Terraform Cloud Workspaces] --> TG
```

## Pipeline Design Diagram

```mermaid
flowchart LR
    Dev[Developer Commit] --> Jenkins[Jenkins Pipeline]

    subgraph App_CI_CD[k8s-pipeline]
      Jenkins --> Clone[Clone demo-app-code]
      Clone --> Build[Build Service with Maven]
      Build --> Image[Build and Push Docker Image]
      Image --> Deploy[Helm Deploy to K8s]
    end

    subgraph Infra_CI_CD[terragrunt-aws/pipelines]
      Jenkins --> NonProd["Jenkinsfile.nonprod<br/>dev/test/perf"]
      Jenkins --> Prod["Jenkinsfile.prod<br/>staging/production"]
      NonProd --> TGApply[deploy.sh plan/apply/destroy]
      Prod --> TGPlan[deploy.sh plan]
      TGPlan --> Approval[Manual Approval]
      Approval --> TGDeploy[deploy.sh apply]
    end
```

## Recommended Workflow

1. Build and validate application modules in [demo-app-code](demo-app-code).
2. Build/push and deploy application workloads via [k8s-pipeline](k8s-pipeline).
3. Provision or update infrastructure using [terragrunt-aws](terragrunt-aws).

## Prerequisites (Workspace Level)

- Git
- Java 8 and Maven 3.8+
- Docker
- Jenkins (for CI/CD pipelines)
- kubectl and Helm (for Kubernetes deployment)
- Terraform and Terragrunt (for infrastructure)
- AWS and Terraform Cloud access (for terragrunt-aws remote runs)

## Notes

- This README is the top-level index for the workspace.
- Component-specific operational details are maintained in each component README.

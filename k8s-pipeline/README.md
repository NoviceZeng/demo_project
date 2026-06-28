# demo-app-k8s-pipeline

Jenkins pipeline and deployment helper scripts for the `demo-app-code` Spring Boot e-commerce demo.

## Overview

This project is the CI/CD companion for the `demo-app-code` monorepo.

The pipeline does the following:

1. Clone the `demo-app-code` monorepo.
2. Build one selected Maven module.
3. Build and push the Docker image for that module.
4. Deploy the selected service to Kubernetes.

## Microservices

Supported service parameters in Jenkins:

- `api-gateway:8080`
- `user-service:9002`
- `product-service:9003`
- `order-service:9006`
- `payment-service:9007`

## Repository Layout

```text
demo-app-k8s-pipeline/
├── Jenkinsfile
├── Jenkinsfile-stage-prod
├── demo-app-helm/
└── scripts/
    ├── git_util.sh
    ├── java_build.sh
    ├── helm_image.sh
    ├── helm_deploy.sh
    └── docker_image.sh
```

## Pipeline Files

- `Jenkinsfile`: pipeline for `dev`, `test`, and `perf`
- `Jenkinsfile-stage-prod`: protected pipeline for `staging` and `production`

## Jenkins Parameters

- `Microsvc`: service module and container port
- `GitBranch`: Git branch in `demo-app-code`
- `TargetEnvironment` in `Jenkinsfile`: `dev`, `test`, `perf`
- `TargetEnvironment` in `Jenkinsfile-stage-prod`: `staging`, `production`
- `ReplicaCount`: Kubernetes replica count
- `BuildOnly`: build and push the image only, skip Kubernetes deployment

## Pipeline Modes

### Full build and deploy

Use the default Jenkins parameters:

- `BuildOnly = false`

Pipeline flow:

1. Clone `demo-app-code`
2. Build the selected Maven module
3. Build and push the Docker image
4. Deploy to Kubernetes

Environment behavior:

- `dev`, `test`, `perf`: use `Jenkinsfile` and deploy directly
- `staging`, `production`: use `Jenkinsfile-stage-prod` and require manual approval before deployment

### Build only

Enable the Jenkins parameter:

- `BuildOnly = true`

Pipeline flow:

1. Clone `demo-app-code`
2. Build the selected Maven module
3. Build and push the Docker image
4. Skip the Kubernetes deployment stage

## Deployment environments

Supported deployment environments across both pipelines:

- `dev`
- `test`
- `perf`
- `staging`
- `production`

Namespace convention:

```text
demo-app-<environment>
```

Examples:

- `demo-app-dev`
- `demo-app-test`
- `demo-app-perf`
- `demo-app-staging`
- `demo-app-production`

## Main Scripts

### `scripts/git_util.sh`

Clones the `demo-app-code` monorepo and checks out the selected branch.

### `scripts/java_build.sh`

Builds one Maven module from the monorepo.

Current command pattern:

```bash
/opt/maven3.8.6/bin/mvn -pl "${microsvc}" -am clean package
```

### `scripts/helm_image.sh`

Builds the Docker image from the selected module directory:

```bash
demo-app-code/<service>
```

It expects each service module to contain its own Dockerfile.

### `scripts/helm_deploy.sh`

Deploys the selected service with Helm.

### `scripts/docker_image.sh`

Fallback image build script that also builds directly from:

```bash
demo-app-code/<service>
```

## Requirements

- Jenkins agent with JDK 8
- Maven 3.8+
- Docker
- kubectl
- Helm
- Access to Harbor registry
- Access to the Kubernetes cluster

## Validation

You can validate the active shell scripts locally with:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-k8s-pipeline
bash -n scripts/git_util.sh
bash -n scripts/java_build.sh
bash -n scripts/helm_image.sh
bash -n scripts/helm_deploy.sh
bash -n scripts/docker_image.sh
```

## Notes

- This pipeline is now aligned to the `demo-app-code` monorepo model.
- The previous per-service repository assumptions have been removed from the active build path.
- Docker image names follow this convention:

```text
<harbor>/vccp/demo-app-<service>:<build-number>
```

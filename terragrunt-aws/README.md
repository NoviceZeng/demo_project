# terragrunt-aws

AWS infrastructure managed with Terraform modules and Terragrunt.

## Results
### Dry run and Apply 
<img width="1174" height="844" alt="image" src="https://github.com/user-attachments/assets/4c950c45-2932-45e4-a778-a262a21a79cb" />
<img width="1179" height="871" alt="image" src="https://github.com/user-attachments/assets/062dd107-ca72-4553-8d17-1de3b4f5823c" />
### AWS Consonle
<img width="1576" height="275" alt="image" src="https://github.com/user-attachments/assets/73e3d362-18c8-4cc6-bd72-1a232eda85c0" />
<img width="1525" height="353" alt="image" src="https://github.com/user-attachments/assets/730aa652-4061-4e39-8a12-8a5238e3c0da" />
### Terraform Cloud
<img width="1296" height="780" alt="image" src="https://github.com/user-attachments/assets/33c6922c-17e6-46be-9d3d-45d049cf92c1" />
## Environments and Regions

- dev, test: us-east-1
- perf, staging, production: us-east-1 and us-west-2

## Repository Layout

```text
terragrunt-aws/
├── root.hcl
├── terraform-modules/
│   ├── aws-network/
│   ├── aws-eks/
│   ├── aws-alb/
│   ├── aws-rds-mysql/
│   └── aws-elasticache-redis/
├── pipelines/
│   ├── Jenkinsfile.nonprod
│   ├── Jenkinsfile.prod
│   └── scripts/
│       ├── deploy.sh
│       └── deploy-resource.sh
└── terragrunt/
    ├── shared/iam-all/
    ├── us-east-1/
    │   ├── dev/
    │   ├── test/
    │   ├── perf/
    │   ├── staging/
    │   └── production/
    └── us-west-2/
        ├── perf/
        ├── staging/
        └── production/
```

## Prerequisites

- Terraform 1.5+
- Terragrunt (latest stable recommended)
- AWS credentials configured (profile, SSO, or environment variables)
- Access to the Terraform Cloud organization defined in [root.hcl](root.hcl)

## Terraform Cloud Credentials (Required for Remote Runs)

This repo uses Terraform Cloud remote execution from [root.hcl](root.hcl), so local AWS CLI credentials are not enough for `terragrunt plan`/`apply`.

Configure AWS credentials in each Terraform Cloud workspace used by this stack:

1. Open the workspace in Terraform Cloud.
2. Go to Variables.
3. Add environment variables:
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `AWS_SESSION_TOKEN` (only for temporary credentials)
    - `AWS_DEFAULT_REGION` (recommended)
4. Re-run Terragrunt command from this repo.

Workspace naming follows this pattern from [root.hcl](root.hcl):

`terragrunt-<path-relative-to-include>`

Example for `terragrunt/us-east-1/dev/network`:

`terragrunt-terragrunt-us-east-1-dev-network`

## Quick Start (Recommended)

From project root:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/terragrunt-aws
```

Full environment deploy:

```bash
./pipelines/scripts/deploy.sh <action> <environment>
```

- action: plan | apply | destroy
- environment: dev | test | perf | staging | production

Single resource deploy:

```bash
./pipelines/scripts/deploy-resource.sh <action> <environment> <resource>
```

- action: plan | apply | destroy
- environment: dev | test | perf | staging | production
- resource: network | eks | load-balancer | rds-mysql | redis

## Common Examples

```bash
# Full environment
./pipelines/scripts/deploy.sh plan dev
./pipelines/scripts/deploy.sh apply test
./pipelines/scripts/deploy.sh plan perf
./pipelines/scripts/deploy.sh apply staging
./pipelines/scripts/deploy.sh destroy production

# Single resource
./pipelines/scripts/deploy-resource.sh plan dev network
./pipelines/scripts/deploy-resource.sh apply test eks
./pipelines/scripts/deploy-resource.sh plan perf load-balancer
./pipelines/scripts/deploy-resource.sh apply perf rds-mysql
./pipelines/scripts/deploy-resource.sh plan staging redis
./pipelines/scripts/deploy-resource.sh destroy production eks
```

## Direct Terragrunt Usage (Without Scripts)

Single-region environment (dev/test):

```bash
cd terragrunt/us-east-1/dev
terragrunt plan --all
terragrunt apply --all
```

Multi-region environment (perf/staging/production):

```bash
cd terragrunt/us-east-1/staging
terragrunt plan --all
terragrunt apply --all

cd ../../us-west-2/staging
terragrunt plan --all
terragrunt apply --all
```

Destroy an environment:

```bash
cd terragrunt/us-east-1/dev
terragrunt destroy --all
```

Destroy a single stack:

```bash
cd terragrunt/us-east-1/perf/network
terragrunt destroy
```

## Jenkins Pipelines

Two Jenkins pipelines are included in [pipelines](pipelines):

- [pipelines/Jenkinsfile.nonprod](pipelines/Jenkinsfile.nonprod): dev, test, perf
- [pipelines/Jenkinsfile.prod](pipelines/Jenkinsfile.prod): staging, production (manual approval gate)

Non-production pipeline parameters:

- TARGET_ENV: dev | test | perf
- ACTION: plan | apply | destroy

Production pipeline parameters:

- TARGET_ENV: staging | production
- APPROVER_IDS: optional comma-separated Jenkins user IDs allowed to approve

Suggested Jenkins job setup:

1. Create a job for non-production and set Pipeline Script Path to pipelines/Jenkinsfile.nonprod.
2. Create a job for staging/production and set Pipeline Script Path to pipelines/Jenkinsfile.prod.
3. Restrict who can trigger and approve production deployments.

## Validation and Formatting

```bash
terraform fmt -check -recursive terraform-modules
terragrunt hcl format
```

## Operational Notes

- Review [root.hcl](root.hcl) and each region/env hcl before rollout.
- Confirm CIDR ranges, node group sizing, and allow-lists match your standards.
- Ensure required secrets are available before deploying stateful services.
- Common variables used by modules include MYSQL_MASTER_PASSWORD and REDIS_AUTH_TOKEN.

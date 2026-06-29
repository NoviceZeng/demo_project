# terragrunt-aws

AWS infrastructure managed with Terraform modules and Terragrunt.

Deployment environments:

- dev
- test
- perf
- staging
- production

Region strategy:

- dev and test: single-region (us-east-1)
- perf, staging, production: multi-region (us-east-1 and us-west-2)

## Structure

```text
terragrunt-aws/
├── root.hcl
├── terraform-modules/
│   ├── aws-network/
│   ├── aws-eks/
│   ├── aws-alb/
│   ├── aws-rds-mysql/
│   └── aws-elasticache-redis/
└── terragrunt/
    ├── shared/
    │   └── iam-all/
    ├── us-east-1/
    │   ├── region.hcl
    │   ├── dev/
    │   │   ├── env.hcl
    │   │   ├── network/
    │   │   ├── eks/
    │   │   ├── load-balancer/
    │   │   ├── rds-mysql/
    │   │   └── redis/
    │   ├── test/
    │   │   ├── env.hcl
    │   │   ├── network/
    │   │   ├── eks/
    │   │   ├── load-balancer/
    │   │   ├── rds-mysql/
    │   │   └── redis/
    │   ├── perf/
    │   │   ├── env.hcl
    │   │   ├── network/
    │   │   ├── eks/
    │   │   ├── load-balancer/
    │   │   ├── rds-mysql/
    │   │   └── redis/
    │   ├── staging/
    │   │   ├── env.hcl
    │   │   ├── network/
    │   │   ├── eks/
    │   │   ├── load-balancer/
    │   │   ├── rds-mysql/
    │   │   └── redis/
    │   └── production/
    │       ├── env.hcl
    │       ├── network/
    │       ├── eks/
    │       ├── load-balancer/
    │       ├── rds-mysql/
    │       └── redis/
    └── us-west-2/
        ├── region.hcl
        ├── perf/
        │   ├── env.hcl
        │   ├── network/
        │   ├── eks/
        │   ├── load-balancer/
        │   ├── rds-mysql/
        │   └── redis/
        ├── staging/
        │   ├── env.hcl
        │   ├── network/
        │   ├── eks/
        │   ├── load-balancer/
        │   ├── rds-mysql/
        │   └── redis/
        └── production/
            ├── env.hcl
            ├── network/
            ├── eks/
            ├── load-balancer/
            ├── rds-mysql/
            └── redis/
```

## Prerequisites

- Terraform >= 1.5
- Terragrunt (newer versions recommended)
- AWS credentials configured (for example via AWS profile, SSO, or environment variables)
- Access to Terraform Cloud organization defined in root.hcl

## How to run resources

### 0) Use deploy script (recommended)

Before deploy, run secret checks:

```bash
./scripts/bootstrap-secrets.sh
```

This project provides an automation script:

```bash
./scripts/deploy.sh <action> <environment>
```

Parameters:

- action: plan | apply | destroy
- environment: dev | test | perf | staging | production

Examples:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/terragrunt-aws

./scripts/deploy.sh plan dev
./scripts/deploy.sh apply test
./scripts/deploy.sh plan perf
./scripts/deploy.sh apply staging
./scripts/deploy.sh destroy production
```

Script behavior:

- dev/test deploy only to us-east-1
- perf/staging/production deploy to us-east-1 and us-west-2

### 0.1) Use single-resource deploy script

When you only want one resource, use:

```bash
./scripts/deploy-resource.sh <action> <environment> <resource>
```

Parameters:

- action: plan | apply | destroy
- environment: dev | test | perf | staging | production
- resource: network | eks | load-balancer | rds-mysql | redis

Examples:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/terragrunt-aws

./scripts/deploy-resource.sh plan dev network
./scripts/deploy-resource.sh apply test eks
./scripts/deploy-resource.sh plan perf load-balancer
./scripts/deploy-resource.sh apply perf rds-mysql
./scripts/deploy-resource.sh plan staging redis
./scripts/deploy-resource.sh destroy production eks
```

Single-resource script behavior:

- dev/test execute only in us-east-1
- perf/staging/production execute in us-east-1 and us-west-2

### 1) Go to project root

```bash
cd /Users/novice/Desktop/test/demo/demo_project/terragrunt-aws
```

### 1.1) Validate secrets and env vars

Run generic check:

```bash
./scripts/bootstrap-secrets.sh
```

Run check for a specific environment:

```bash
./scripts/bootstrap-secrets.sh production
```

Set required and optional variables:

```bash
export MYSQL_MASTER_PASSWORD='StrongPassword123!'
export REDIS_AUTH_TOKEN='YourRedisAuthToken'
```

### 2) Deploy a full environment (single region)

Run all resources in dependency order (Network -> RDS/Redis -> EKS -> ALB):

```bash
cd terragrunt/us-east-1/dev
terragrunt run-all plan
terragrunt run-all apply
```

For test:

```bash
cd ../test
terragrunt run-all plan
terragrunt run-all apply
```

### 3) Deploy a multi-region environment (perf, staging, production)

Run both regions separately for the same environment.

Recommended order in each region:

1. network
2. rds-mysql
3. redis
4. eks
5. load-balancer

Perf:

```bash
cd terragrunt/us-east-1/perf
terragrunt run-all plan
terragrunt run-all apply

cd ../../us-west-2/perf
terragrunt run-all plan
terragrunt run-all apply
```

Staging:

```bash
cd terragrunt/us-east-1/staging
terragrunt run-all plan
terragrunt run-all apply

cd ../../us-west-2/staging
terragrunt run-all plan
terragrunt run-all apply
```

Production:

```bash
cd terragrunt/us-east-1/production
terragrunt run-all plan
terragrunt run-all apply

cd ../../us-west-2/production
terragrunt run-all plan
terragrunt run-all apply
```

### 4) Deploy a single resource

Network:

```bash
cd terragrunt/us-east-1/perf/network
terragrunt plan
terragrunt apply
```

EKS (depends on Network):

```bash
cd ../eks
terragrunt plan
terragrunt apply
```

ALB (depends on Network and EKS):

```bash
cd ../load-balancer
terragrunt plan
terragrunt apply
```

MySQL RDS (depends on Network):

```bash
cd ../rds-mysql
terragrunt plan
terragrunt apply
```

Redis (depends on Network):

```bash
cd ../redis
terragrunt plan
terragrunt apply
```

### 5) Shared IAM stack

```bash
cd terragrunt/shared/iam-all
terragrunt plan
terragrunt apply
```

## Validate and format

From project root:

```bash
terraform fmt -check -recursive terraform-modules
terragrunt hcl format
```

## Destroy resources

Destroy a full environment:

```bash
cd terragrunt/us-east-1/dev
terragrunt run-all destroy
```

Destroy a multi-region environment (example: staging):

```bash
cd terragrunt/us-east-1/staging
terragrunt run-all destroy

cd ../../us-west-2/staging
terragrunt run-all destroy
```

Destroy a single stack:

```bash
cd terragrunt/us-east-1/perf/network
terragrunt destroy
```

## Notes

- The Terragrunt files include dependency blocks and mock outputs for plan/validate workflows.
- Environment-specific sizing and CIDR settings are defined in each env.hcl.
- Tune CIDR ranges, node group sizes, and allowed CIDRs to match your network/security standards.
- Review root.hcl and region.hcl values (region, tags, Terraform Cloud workspace naming) before rollout.
- Set MYSQL_MASTER_PASSWORD before deploying RDS, for example: export MYSQL_MASTER_PASSWORD='StrongPassword123!'.
- Optionally set REDIS_AUTH_TOKEN for Redis auth: export REDIS_AUTH_TOKEN='YourRedisAuthToken'.

## Scripts Summary

- scripts/deploy.sh: Run full environment with terragrunt run-all.
- scripts/deploy-resource.sh: Run a single resource (network/eks/load-balancer/rds-mysql/redis).
- scripts/bootstrap-secrets.sh: Validate required/optional secret environment variables.

#!/usr/bin/env bash

# Strict mode: exit immediately on any error to avoid unsafe continuation
set -euo pipefail

# Script purpose: run terragrunt plan/apply/destroy for a single resource
# Supported resources: network | eks | load-balancer | rds-mysql | redis
# Environment strategy:
# - dev/test: single region us-east-1
# - perf/staging/production: multi-region us-east-1 + us-west-2

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
TG_DIR="$ROOT_DIR/terragrunt"

usage() {
  cat <<'EOF'
Usage:
  ./pipelines/scripts/deploy-resource.sh <action> <environment> <resource>

Arguments:
  action       plan | apply | destroy
  environment  dev | test | perf | staging | production
  resource     network | eks | load-balancer | rds-mysql | redis

Examples:
  ./pipelines/scripts/deploy-resource.sh plan dev network
  ./pipelines/scripts/deploy-resource.sh apply test eks
  ./pipelines/scripts/deploy-resource.sh plan perf load-balancer
  ./pipelines/scripts/deploy-resource.sh apply perf rds-mysql
  ./pipelines/scripts/deploy-resource.sh plan staging redis
  ./pipelines/scripts/deploy-resource.sh destroy production eks

Behavior:
  dev/test                 -> us-east-1 only
  perf/staging/production  -> us-east-1 and us-west-2
EOF
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: command not found: $cmd"
    exit 1
  fi
}

resolve_regions() {
  local env="$1"
  case "$env" in
    dev|test)
      echo "us-east-1"
      ;;
    perf|staging|production)
      echo "us-east-1 us-west-2"
      ;;
    *)
      echo ""
      ;;
  esac
}

validate_resource() {
  local resource="$1"
  case "$resource" in
    network|eks|load-balancer|rds-mysql|redis)
      ;;
    *)
      echo "Error: invalid resource: $resource"
      usage
      exit 1
      ;;
  esac
}

run_for_region_env_resource() {
  local action="$1"
  local region="$2"
  local env="$3"
  local resource="$4"
  local target="$TG_DIR/$region/$env/$resource"

  if [[ ! -d "$target" ]]; then
    echo "Error: target path not found: $target"
    exit 1
  fi

  echo "=================================================="
  echo "Running terragrunt $action in: $target"
  echo "=================================================="

  (cd "$target" && terragrunt "$action")
}

main() {
  require_cmd terragrunt

  if [[ $# -ne 3 ]]; then
    usage
    exit 1
  fi

  local action="$1"
  local env="$2"
  local resource="$3"

  case "$action" in
    plan|apply|destroy)
      ;;
    *)
      echo "Error: invalid action: $action"
      usage
      exit 1
      ;;
  esac

  validate_resource "$resource"

  local regions
  regions="$(resolve_regions "$env")"
  if [[ -z "$regions" ]]; then
    echo "Error: invalid environment: $env"
    usage
    exit 1
  fi

  echo "Project root: $ROOT_DIR"
  echo "Action      : $action"
  echo "Environment : $env"
  echo "Resource    : $resource"
  echo "Regions     : $regions"

  # Execute per region and per resource so logs and failure points stay clear
  for region in $regions; do
    run_for_region_env_resource "$action" "$region" "$env" "$resource"
  done

  echo "Done: terragrunt $action for '$env/$resource'."
}

main "$@"

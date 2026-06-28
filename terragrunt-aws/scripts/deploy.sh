#!/usr/bin/env bash

# Strict mode: exit immediately on any error to avoid unsafe continuation
set -euo pipefail

# Script purpose: run terragrunt run-all plan/apply/destroy in a unified way
# Environment strategy:
# - dev/test: single region us-east-1
# - perf/staging/production: multi-region us-east-1 + us-west-2

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TG_DIR="$ROOT_DIR/terragrunt"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/deploy.sh <action> <environment>

Arguments:
  action       plan | apply | destroy
  environment  dev | test | perf | staging | production

Examples:
  ./scripts/deploy.sh plan dev
  ./scripts/deploy.sh apply test
  ./scripts/deploy.sh plan perf
  ./scripts/deploy.sh apply staging
  ./scripts/deploy.sh destroy production

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

run_for_region_env() {
  local action="$1"
  local region="$2"
  local env="$3"
  local target="$TG_DIR/$region/$env"

  if [[ ! -d "$target" ]]; then
    echo "Error: target path not found: $target"
    exit 1
  fi

  echo "=================================================="
  echo "Running terragrunt run-all $action in: $target"
  echo "=================================================="

  (cd "$target" && terragrunt run-all "$action")
}

main() {
  require_cmd terragrunt

  if [[ $# -ne 2 ]]; then
    usage
    exit 1
  fi

  local action="$1"
  local env="$2"

  case "$action" in
    plan|apply|destroy)
      ;;
    *)
      echo "Error: invalid action: $action"
      usage
      exit 1
      ;;
  esac

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
  echo "Regions     : $regions"

  # Execute region by region so logs and failure points remain clear
  for region in $regions; do
    run_for_region_env "$action" "$region" "$env"
  done

  echo "Done: terragrunt run-all $action for environment '$env'."
}

main "$@"

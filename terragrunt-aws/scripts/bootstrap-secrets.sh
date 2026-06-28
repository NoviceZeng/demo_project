#!/usr/bin/env bash

set -euo pipefail

# This script validates environment variables used by stateful resources.
# It does not print secret values; it only reports whether a variable is set.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/bootstrap-secrets.sh [environment]

Arguments:
  environment  Optional. dev | test | perf | staging | production

Examples:
  ./scripts/bootstrap-secrets.sh
  ./scripts/bootstrap-secrets.sh dev
  ./scripts/bootstrap-secrets.sh production

Checks:
  Required (all environments): MYSQL_MASTER_PASSWORD
  Optional: REDIS_AUTH_TOKEN
EOF
}

validate_env_name() {
  local env_name="$1"
  case "$env_name" in
    dev|test|perf|staging|production)
      ;;
    *)
      echo "Error: invalid environment: $env_name"
      usage
      exit 1
      ;;
  esac
}

print_result() {
  local label="$1"
  local status="$2"
  printf "%-28s %s\n" "$label" "$status"
}

main() {
  local env_name=""
  if [[ $# -gt 1 ]]; then
    usage
    exit 1
  fi

  if [[ $# -eq 1 ]]; then
    env_name="$1"
    validate_env_name "$env_name"
  fi

  echo "Project root: $ROOT_DIR"
  if [[ -n "$env_name" ]]; then
    echo "Environment : $env_name"
  else
    echo "Environment : all (generic check)"
  fi
  echo

  local has_error=0

  if [[ -n "${MYSQL_MASTER_PASSWORD:-}" ]]; then
    print_result "MYSQL_MASTER_PASSWORD" "SET"
  else
    print_result "MYSQL_MASTER_PASSWORD" "MISSING (required)"
    has_error=1
  fi

  if [[ -n "${REDIS_AUTH_TOKEN:-}" ]]; then
    print_result "REDIS_AUTH_TOKEN" "SET (optional)"
  else
    print_result "REDIS_AUTH_TOKEN" "NOT SET (optional)"
  fi

  echo
  if [[ $has_error -eq 1 ]]; then
    echo "Result: FAILED"
    echo "Set missing required variables, then re-run this script."
    exit 1
  fi

  echo "Result: PASSED"
  echo "You can proceed with deploy scripts."
}

main "$@"

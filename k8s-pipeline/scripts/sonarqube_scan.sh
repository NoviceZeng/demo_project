#!/bin/bash

# SonarQube Code Scanning Script
# Usage: sonarqube_scan.sh <microsvc> <sonarqube_host_url> <sonarqube_login>

set -e

MICROSVC=$1
SONARQUBE_HOST_URL=$2
SONARQUBE_LOGIN=$3

if [ -z "$MICROSVC" ] || [ -z "$SONARQUBE_HOST_URL" ] || [ -z "$SONARQUBE_LOGIN" ]; then
    echo "Error: Missing required parameters"
    echo "Usage: sonarqube_scan.sh <microsvc> <sonarqube_host_url> <sonarqube_login>"
    exit 1
fi

echo "Starting SonarQube scan for ${MICROSVC}..."

cd "${MICROSVC}"

sonar-scanner \
  -Dsonar.projectKey=demo-app-${MICROSVC} \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONARQUBE_HOST_URL} \
  -Dsonar.login=${SONARQUBE_LOGIN}

if [ $? -eq 0 ]; then
    echo "SonarQube scan PASSED for ${MICROSVC}"
    exit 0
else
    echo "SonarQube scan FAILED for ${MICROSVC}"
    exit 1
fi

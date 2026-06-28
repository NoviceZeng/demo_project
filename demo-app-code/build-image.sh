#!/bin/bash
set -e

microsvc=$1
harbor=$2
build_number=$3

shift 3

skip_package="false"
skip_push="false"

for arg in "$@"; do
    case "$arg" in
        skip-package)
            skip_package="true"
            ;;
        skip-push)
            skip_push="true"
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Usage: ./build-image.sh <service> <harbor> <tag> [skip-package] [skip-push]"
            exit 1
            ;;
    esac
done

service_dir="$microsvc"
svc_name="demo-app-${microsvc}"
image_name="${harbor}/demo-app/${svc_name}:${build_number}"

if [[ ! -d "$service_dir" ]]; then
    echo "Service directory not found: $service_dir"
    exit 1
fi

if [[ "$skip_package" != "true" ]]; then
    if command -v mvn >/dev/null 2>&1; then
        mvn_cmd="mvn"
    elif [[ -x /opt/maven3.8.6/bin/mvn ]]; then
        mvn_cmd="/opt/maven3.8.6/bin/mvn"
    else
        echo "Maven executable not found. Install mvn or provide /opt/maven3.8.6/bin/mvn."
        exit 1
    fi

    "$mvn_cmd" -pl "$microsvc" -am clean package
fi

cd "$service_dir" || exit 1

cat Dockerfile
docker build -t "$image_name" .

if [[ "$skip_push" != "true" ]]; then
    docker push "$image_name"
fi
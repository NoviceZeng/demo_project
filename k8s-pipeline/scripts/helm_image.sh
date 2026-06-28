#!/bin/bash
#set -x
# exit when encounter an  error
set -e
microsvc=$(echo "$1" | cut -d":" -f 1)
harbor=$2
build_number=$3
bash demo-app-code/build-image.sh "${microsvc}" "${harbor}" "${build_number}" skip-package
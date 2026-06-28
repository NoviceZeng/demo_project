#!/bin/bash
set -x
set -e
microsvc=$(echo "$1" | cut -d":" -f 1)
port=$(echo "$1" | cut -d":" -f 2)
target_environment=$2
namespace="demo-app-"${target_environment}
build_number=$3
replica_count=$4
svc_name="demo-app-"${microsvc}
harbor_repo=${Harbor_Repo:?Harbor_Repo is required}
harbor_password=${Harbor_Password:?Harbor_Password is required}
helm_args="--set namespace=${namespace} --set replicaCount=${replica_count} --set image.microSvc=${microsvc} --set image.tag=${build_number} --set service.port=${port} --set envType=${target_environment} -n ${namespace}"

#if namespace doesn`t exit, then create it 
[[ $(kubectl get namespace "$namespace" | grep -c "$namespace" ) -eq 0 ]] && kubectl create namespace "$namespace" 

#if registry-pull-secret doesn`t exit, then create it 
[[ $(kubectl get secret "registry-pull-secret" -n "$namespace" | grep -c "registry-pull-secret" ) -eq 0 ]] && kubectl create secret docker-registry registry-pull-secret --docker-username=admin --docker-password="${harbor_password}" --docker-server="${harbor_repo}" -n "$namespace"

#judge if it`s a new deploying
if [[ $(helm list --namespace "$namespace" | grep -c "$microsvc" ) -gt 0 ]]; then
  action=upgrade
else
  action=install
fi

#deploy micro service
if [[ $microsvc == "api-gateway" ]]; then
  helm ${action} "$microsvc" ${helm_args} --set ingress.enabled=true --set service.enabled=true vccp_repo/demo-app
else
  helm ${action} "$microsvc" ${helm_args} vccp_repo/demo-app
fi

helm list --namespace "$namespace"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++Pls wait and the $svc_name svc is starting+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
kubectl rollout status deployment/"${svc_name}" -n "$namespace"
if [[ "$?" -ne 0 ]]; then
    error "Deployment is failed!"
else
    info "Deployment is succeed!"
fi

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++The $svc_name started, pls check the $svc_name logs+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
POD_NAMES=$(kubectl get pods -n "$namespace" | grep "$svc_name" | awk '{print $1}')
for POD_NAME in $POD_NAMES; do
    kubectl logs "$POD_NAME" "$APP_NAME" -n "$namespace"
    kubectl describe pod "$POD_NAME" -n "$namespace"
done
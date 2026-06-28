#!/bin/bash
set -x
branch=$2
svc_repo=$3
repo_name="demo-app-code"

[[ ! -d "${repo_name}" ]] && git clone "${svc_repo}${repo_name}"".git"
cd "${repo_name}" || exit
git stash
git pull
git checkout "${branch}"
CHECKOUT_BRANCH=$(git symbolic-ref --short HEAD)
[[ "$CHECKOUT_BRANCH" != "$branch" ]] && echo "Branch checkout failed, current branch is ${CHECKOUT_BRANCH}" && exit 1
git pull

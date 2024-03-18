#!/bin/bash
set -eu
# DEPLOY_KEY=/app/.ssh/ssh.private
WORKDIR="${WORKDIR:-/app/clone}"

_help() {
  echo """
  Deployer - change k8s manifest and commit changes

  Args:
  -f -- file to be changed and commited
  -k -- (key) - yaml path in -f(ile) to be changed
  -v -- (value) - new values to be set for -k(ey)

  Envs:
  DEPLOY_KEY -- plain ssh key to be used to commit
  WORKDIR -- optional, workdir to clone and commit changes
"""
}

# ./deploy.sh -f test/test.yaml -k .global.key -v latest
while getopts ":f:k:v:" opt; do
  case $opt in
    f) FILE=$(printf '%s\n' "${OPTARG//[[:space:]]}")
    ;;
    k) YKEY=$(printf '%s\n' "${OPTARG//[[:space:]]}")
    ;;
    v) YVALUE=$(printf '%s\n' "${OPTARG//[[:space:]]}")
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    _help
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    _help
    exit 1
    ;;
  esac
done

git_config() {
  eval $(ssh-agent -s)
  # echo "${DEPLOY_KEY}" | tr -d '\r' | ssh-add - # TODO

  # In kubernetes, key will be mounted as RO with 0444
  # Workaround - Copy ssh key to /tmp
  cp "${DEPLOY_KEY}" /tmp/key
  chmod 400 /tmp/key
  ssh-add /tmp/key
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
  ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts
  git config --global user.name "${GIT_USERNAME:-'bot'}"
  git config --global user.email "${GIT_EMAIL:-'bot@example.com'}"
}

git_pull() {
  git clone "${REPO}" "${WORKDIR}"
  cd ${WORKDIR}
  git checkout "${REVISION}"
}

file_update() {
  cd ${WORKDIR}
  REPLACE=''."${YKEY}=\"${YVALUE}\""''
  ls -la
  yq --inplace "${REPLACE}" "${WORKDIR}/${FILE}"
}

git_commit() {
  cd ${WORKDIR}
  git add ${FILE}
  git commit -m "${FILE}: ${YVALUE}"
  git push origin "${REVISION}"
}

prepare() {
  rm -rf ${WORKDIR}/* || echo "No files to delete"
}

prepare
git_config
git_pull
file_update
git_commit

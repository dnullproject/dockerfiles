#!/bin/bash
set -eu

# ./deploy.sh -f test/test.yaml -k .global.key -v latest
while getopts ":f:k:v:" opt; do
  case $opt in
    f) FILE="$OPTARG"
    ;;
    k) YKEY="$OPTARG"
    ;;
    v) YVALUE="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

git_config() {
  eval $(ssh-agent -s)
  # echo "${DEPLOY_KEY}" | tr -d '\r' | ssh-add - # TODO
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
  ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts
  git config --global user.name "deployer bot"
  git config --global user.email "deployer@example.com" # TODO
}

file_update() {
  yq --inplace ''${YKEY}'="'${YVALUE}'"' "${FILE}"
}

git_commit() {
  git add ${FILE}
  git commit -m "${FILE} - ${IMAGE}"
  git push origin ${REV:-main}
}

file_update

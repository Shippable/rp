#!/bin/bash -e

export BRANCH=master
export IMAGE_NAME=shipimg/rp
export IMAGE_TAG=$BRANCH.$BUILD_NUMBER
export RES_DOCKER_CREDS=docker-creds
export RES_RP_REPO=rp-repo
export RES_RP_IMAGE=rp-img
export RES_MICRO_IMAGE=microbase-img

findUpstreamMicroBaseVersion() {
  echo "Find Latest Version for" $RES_MICRO_IMAGE
  export versionName=$(cat ./IN/$RES_MICRO_IMAGE/version.json | jq -r '.version.versionName')
  echo "Completed find Latest Version for" $RES_MICRO_IMAGE
}


dockerBuild() {
  echo "Starting Docker build for" $IMAGE_NAME:$IMAGE_TAG
  cd ./IN/$RES_RP_REPO/gitRepo
  sed -i "s/{{%TAG%}}/$versionName/g" Dockerfile
  sudo docker build -t=$IMAGE_NAME:$IMAGE_TAG .
  echo "Completed Docker build for" $IMAGE_NAME:$IMAGE_TAG
}

dockerPush() {
  echo "Starting Docker push for" $IMAGE_NAME:$IMAGE_TAG
  sudo docker push $IMAGE_NAME:$IMAGE_TAG
  echo "Completed Docker push for" $IMAGE_NAME:$IMAGE_TAG
}

dockerLogin() {
  echo "Extracting docker creds"
  . ./IN/$RES_DOCKER_CREDS/integration.env
  echo "logging into Docker with username" $username
  docker login -u $username -p $password
  echo "Completed Docker login"
}

createOutState() {
  echo "Creating a state file for" $RES_RP_IMAGE
  echo versionName=$IMAGE_TAG > /build/state/$RES_RP_IMAGE.env
  echo "Completed creating a state file for" $RES_RP_IMAGE
}

main() {
  findUpstreamMicroBaseVersion
  dockerLogin
  dockerBuild
  dockerPush
  createOutState
}

main

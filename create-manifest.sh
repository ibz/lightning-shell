#!/usr/bin/env bash

IMAGE_NAME=${1}
VERSION=${2}
BASE_IMAGE=${3}
VERSION_PREFIX="${VERSION}-${BASE_IMAGE}"
FINAL_NAME="${IMAGE_NAME}:${VERSION}-${BASE_IMAGE}"
declare -a architectures=("amd64" "arm64")

for architecture in "${architectures[@]}"; do
  echo "Pulling ${VERSION} for ${architecture}..."
  docker pull "${FINAL_NAME}-${architecture}"
done

echo "Creating manifest list..."
for architecture in "${architectures[@]}"; do
  echo " ${FINAL_NAME}-${architecture}"
done | xargs docker manifest create "${FINAL_NAME}"

for architecture in "${architectures[@]}"; do
  echo "Annotating manifest for ${architecture}..."
  docker manifest annotate "${FINAL_NAME}" "${FINAL_NAME}-${architecture}" --arch ${architecture} --os linux
done

echo "Pushing manifest list..."
docker manifest push --purge ${FINAL_NAME}

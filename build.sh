#!/bin/bash

trap "exit" INT

IMAGE_NAME=${1}
VERSION=${2}
declare -a architectures=("amd64" "arm64")
lnd_version='v0.14.1-beta'

for architecture in "${architectures[@]}"; do
  echo "Building ${VERSION} for ${architecture}..."
  docker buildx build --platform linux/${architecture} \
    --tag ${IMAGE_NAME}:${VERSION}-${architecture} --output "type=registry" \
    --build-arg arch=${architecture} \
    --build-arg version=${VERSION} \
    --build-arg lnd_version=${lnd_version} \
    .
done

echo "Creating manifest list..."
for architecture in "${architectures[@]}"; do
  echo " ${IMAGE_NAME}-${architecture}:${VERSION}"
done | xargs docker manifest create ${IMAGE_NAME}:${VERSION}

for architecture in "${architectures[@]}"; do
  echo "Annotating manifest for ${architecture}..."
  docker manifest annotate ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}-${architecture}:${VERSION} --arch ${architecture} --os linux
done

echo "Pushing manifest list..."
docker manifest push --purge ${IMAGE_NAME}:${VERSION}

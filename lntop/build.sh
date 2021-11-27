#!/bin/bash

VERSION=v0.0.6

declare -a architectures=("amd64" "arm64")

for architecture in "${architectures[@]}"; do
  echo "Building ${VERSION} for ${architecture}..."
  docker buildx build --platform linux/${architecture} --tag ibz0/lntop-${architecture}:${VERSION} --output "type=registry" --build-arg arch=${architecture} .
done

echo "Creating manifest list..."
for architecture in "${architectures[@]}"; do
  echo " ibz0/lntop-${architecture}:${VERSION}"
done | xargs docker manifest create ibz0/lntop:${VERSION}

for architecture in "${architectures[@]}"; do
  echo "Annotating manifest for ${architecture}..."
  docker manifest annotate ibz0/lntop:${VERSION} ibz0/lntop-${architecture}:${VERSION} --arch ${architecture} --os linux
done

echo "Pushing manifest list..."
docker manifest push --purge ibz0/lntop:${VERSION}

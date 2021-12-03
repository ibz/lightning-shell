#!/bin/bash

VERSION=v0.1.0

declare -a architectures=("amd64" "arm64")

for architecture in "${architectures[@]}"; do
  echo "Building ${VERSION} for ${architecture}..."
  docker buildx build --platform linux/${architecture} --tag ibz0/wesh-${architecture}:${VERSION} --output "type=registry" --build-arg arch=${architecture} .
done

echo "Creating manifest list..."
for architecture in "${architectures[@]}"; do
  echo " ibz0/wesh-${architecture}:${VERSION}"
done | xargs docker manifest create ibz0/wesh:${VERSION}

for architecture in "${architectures[@]}"; do
  echo "Annotating manifest for ${architecture}..."
  docker manifest annotate ibz0/wesh:${VERSION} ibz0/wesh-${architecture}:${VERSION} --arch ${architecture} --os linux
done

echo "Pushing manifest list..."
docker manifest push --purge ibz0/wesh:${VERSION}

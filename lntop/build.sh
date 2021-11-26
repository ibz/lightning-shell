#!/bin/bash

declare -a architectures=("amd64" "arm64")

for architecture in "${architectures[@]}"; do
  echo "Building $1 for ${architecture}..."
  docker buildx build --platform linux/${architecture} --tag ibz0/lntop-${architecture}:$1 --output "type=registry" --build-arg arch=${architecture} .
done

echo "Creating manifest list..."
for architecture in "${architectures[@]}"; do
  echo " ibz0/lntop-${architecture}:$1"
done | xargs docker manifest create ibz0/lntop:$1

for architecture in "${architectures[@]}"; do
  echo "Annotating manifest for ${architecture}..."
  docker manifest annotate ibz0/lntop:$1 ibz0/lntop-${architecture}:$1 --arch ${architecture} --os linux
done

echo "Pushing manifest list..."
docker manifest push --purge ibz0/lntop:$1

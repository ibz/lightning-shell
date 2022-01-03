#!/bin/bash

trap "exit" INT

VERSION=v0.3.2

declare -a architectures=("amd64" "arm64")

go_version='1.17.4'
declare -A go_checksums
go_checksums['amd64']='adab2483f644e2f8a10ae93122f0018cef525ca48d0b8764dae87cb5f4fd4206'
go_checksums['arm64']='617a46bd083e59877bb5680998571b3ddd4f6dcdaf9f8bf65ad4edc8f3eafb13'

lnd_version='v0.14.1-beta'

for architecture in "${architectures[@]}"; do
  echo "Building ${VERSION} for ${architecture}..."
  docker buildx build --platform linux/${architecture} \
    --tag ibz0/wesh-${architecture}:${VERSION} --output "type=registry" \
    --build-arg arch=${architecture} \
    --build-arg go_version=${go_version} \
    --build-arg go_checksum=${go_checksums[${architecture}]} \
    --build-arg lnd_version=${lnd_version} \
    .
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

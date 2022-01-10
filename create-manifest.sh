#!/usr/bin/env bash

IMAGE_NAME=${1}
VERSION=${2}
BASE_IMAGE=${3}
VERSION_PREFIX="${VERSION}-${BASE_IMAGE}"
FINAL_NAME="${IMAGE_NAME}:${VERSION_PREFIX}"
# Manifest name is "${IMAGE_NAME}:${VERSION}" if $4 is true, $FINAL_NAME otherwise
if [[ "${4}" == "true" ]]; then
    MANIFEST_NAME="${IMAGE_NAME}:${VERSION}"
else
    MANIFEST_NAME="${FINAL_NAME}"
fi
declare -a architectures=("amd64" "arm64")

for architecture in "${architectures[@]}"; do
  echo "Pulling ${VERSION} for ${architecture}..."
  docker pull "${FINAL_NAME}-${architecture}"
done

echo "Creating manifest list..."
for architecture in "${architectures[@]}"; do
  echo " ${FINAL_NAME}-${architecture}"
done | xargs docker manifest create "${MANIFEST_NAME}"

for architecture in "${architectures[@]}"; do
  echo "Annotating manifest for ${architecture}..."
  docker manifest annotate "${MANIFEST_NAME}" "${FINAL_NAME}-${architecture}" --arch ${architecture} --os linux
done

echo "Pushing manifest list..."
docker manifest push --purge ${MANIFEST_NAME}

# If $4 isn't true and $BASE_IMAGE is bullseye, rerun this script with $4 set to true
if [[ "${4}" != "true" && "${BASE_IMAGE}" == "bullseye" ]]; then
    ./create-manifest.sh "${IMAGE_NAME}" "${VERSION}" "${BASE_IMAGE}" "true"
fi

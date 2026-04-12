#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-tailitium:local}"
PLATFORM="${PLATFORM:-linux/$(docker version --format '{{.Server.Arch}}' | sed 's/aarch64/arm64/') }"
PLATFORM="${PLATFORM// /}"

echo "Building ${IMAGE_NAME} for ${PLATFORM} and loading it into local Docker..."
docker buildx build \
  --platform "${PLATFORM}" \
  -t "${IMAGE_NAME}" \
  --load \
  .

echo "Done."

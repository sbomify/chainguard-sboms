#!/bin/bash
set -e

# Check if image name is provided
if [ -z "$1" ]; then
  echo "Error: Image name is required"
  echo "Usage: $0 <image_name>"
  exit 1
fi

IMAGE="$1"

# Pull the image
echo "Pulling image cgr.dev/chainguard/$IMAGE..."
docker pull "cgr.dev/chainguard/$IMAGE"

# Get SBOM
echo "Downloading SBOM attestation..."
cosign download attestation \
    --platform linux/amd64 \
    --predicate-type=https://spdx.dev/Document \
    "cgr.dev/chainguard/$IMAGE:latest" | \
    jq '.payload | @base64d | fromjson | .predicate' > sbom.spdx.json

echo "SBOM saved to sbom.spdx.json"

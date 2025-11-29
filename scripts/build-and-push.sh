#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <dockerhub-username> [tag]"
  exit 1
fi

USERNAME="$1"
TAG="${2:-latest}"
IMAGE="${USERNAME}/leads-manager:${TAG}"

echo "Building image ${IMAGE} from MidtermProj..."
docker build -t "${IMAGE}" MidtermProj
echo "Push with: docker push ${IMAGE}"

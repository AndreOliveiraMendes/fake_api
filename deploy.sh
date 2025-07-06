#!/bin/bash

# CONFIG
IMAGE_NAME="fake_api"
CONTAINER_NAME="fake_api_server"
PORT="5001:5001"

DRY_RUN=false
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
  fi
done

echo "======================================"
echo "📦 Deploy script for $IMAGE_NAME"
echo "Dry run mode: $DRY_RUN"
echo "======================================"

# STEP 1: STOP container if running
echo "🛑 Stopping existing container (if any)..."
if $DRY_RUN; then
  echo "> podman stop $CONTAINER_NAME || true"
else
  podman stop $CONTAINER_NAME || true
fi

# STEP 2: REMOVE container
echo "🗑️ Removing existing container..."
if $DRY_RUN; then
  echo "> podman rm $CONTAINER_NAME || true"
else
  podman rm $CONTAINER_NAME || true
fi

# STEP 3: BUILD image
echo "🔨 Building new image..."
if $DRY_RUN; then
  echo "> podman build -t $IMAGE_NAME ."
else
  podman build -t $IMAGE_NAME .
fi

# STEP 4: LIST images
echo "📦 Available images:"
if $DRY_RUN; then
  echo "> podman images | grep $IMAGE_NAME"
else
  podman images | grep $IMAGE_NAME
fi

# STEP 5: RUN new container
echo "🚀 Starting new container..."
if $DRY_RUN; then
  echo "> podman run -d --name $CONTAINER_NAME -p $PORT $IMAGE_NAME"
else
  podman run -d --name $CONTAINER_NAME -p $PORT $IMAGE_NAME
fi

echo "✅ Done!"

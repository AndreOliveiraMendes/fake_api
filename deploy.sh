#!/bin/bash

# CONFIG
IMAGE_NAME="fake_api"
CONTAINER_NAME="fake_api_server"
PORT="5001:5001"
VOLUME_PATH="$HOME/fake_api_data:/app/data"
ENV_FILE=".env"

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

echo "🛑 Stopping existing container..."
if $DRY_RUN; then
  echo "> podman stop $CONTAINER_NAME || true"
else
  podman stop $CONTAINER_NAME || true
fi

echo "🗑️ Removing existing container..."
if $DRY_RUN; then
  echo "> podman rm $CONTAINER_NAME || true"
else
  podman rm $CONTAINER_NAME || true
fi

echo "🔨 Building new image..."
if $DRY_RUN; then
  echo "> podman build -t $IMAGE_NAME ."
else
  podman build -t $IMAGE_NAME .
fi

echo "🚀 Starting new container..."
if $DRY_RUN; then
  echo "> podman run -d --name $CONTAINER_NAME -p $PORT -v $VOLUME_PATH --env-file $ENV_FILE $IMAGE_NAME"
else
  podman run -d --name $CONTAINER_NAME -p $PORT -v $VOLUME_PATH --env-file $ENV_FILE $IMAGE_NAME
fi

echo "✅ Done!"

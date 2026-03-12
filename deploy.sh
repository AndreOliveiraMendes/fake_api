#!/bin/bash

# CONFIG
IMAGE_NAME="fake_api"
CONTAINER_NAME="fake_api_server"
PORT="5001:5001"
VOLUME_PATH="$HOME/fake_api_data_local:/app/data"
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

# Detect container engine
ENGINE=""

if command -v podman >/dev/null 2>&1 && command -v docker >/dev/null 2>&1; then
  echo "⚙️  Both Podman and Docker detected."
  echo "Choose container engine:"
  select choice in "podman" "docker"; do
    ENGINE=$choice
    break
  done
elif command -v podman >/dev/null 2>&1; then
  ENGINE="podman"
  echo "🐧 Podman detected."
elif command -v docker >/dev/null 2>&1; then
  ENGINE="docker"
  echo "🐳 Docker detected."
else
  echo "❌ Neither Docker nor Podman is installed."
  exit 1
fi

echo "➡️ Using: $ENGINE"
echo ""

run_cmd() {
  if $DRY_RUN; then
    echo "> $*"
  else
    eval "$@"
  fi
}

echo "🛑 Stopping existing container..."
run_cmd "$ENGINE stop $CONTAINER_NAME || true"

echo "🗑️ Removing existing container..."
run_cmd "$ENGINE rm $CONTAINER_NAME || true"

echo "🔨 Building new image..."
run_cmd "$ENGINE build -t $IMAGE_NAME ."

echo "🚀 Starting new container..."
run_cmd "$ENGINE run -d --name $CONTAINER_NAME -p $PORT -v $VOLUME_PATH --env-file $ENV_FILE $IMAGE_NAME"

echo "✅ Done!"
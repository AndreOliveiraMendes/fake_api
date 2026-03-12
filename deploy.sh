#!/bin/bash
set -euo pipefail

# Colors
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

info()    { echo -e "${BLUE}ℹ${RESET} $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET} $*"; }
error()   { echo -e "${RED}✖${RESET} $*"; }
success() { echo -e "${GREEN}✔${RESET} $*"; }

show_help() {
cat << EOF
${BOLD}Deploy script for fake_api${RESET}

${CYAN}Usage:${RESET}
  ./deploy.sh [OPTIONS]

${CYAN}Options:${RESET}
  -h, --help       Show this help message and exit
  --dry-run        Print commands without executing them

${CYAN}Description:${RESET}
  This script builds and runs the fake_api container using Docker or Podman.
  It automatically detects which container engine is available.

${CYAN}Data directory priority:${RESET}
  1. \$HOME/fake_api_data_local
  2. <script_dir>/data

${CYAN}Examples:${RESET}
  ./deploy.sh
  ./deploy.sh --dry-run
EOF
}

# Parse arguments
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      show_help
      exit 0
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
  esac
done

# CONFIG
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HOME_DATA="$HOME/fake_api_data_local"
SCRIPT_DATA="$SCRIPT_DIR/data"

if [[ -d "$HOME_DATA" ]]; then
  DATA_PATH="$HOME_DATA"
else
  DATA_PATH="$SCRIPT_DATA"
fi

IMAGE_NAME="fake_api"
CONTAINER_NAME="fake_api_server"
PORT="5001:5001"
VOLUME_PATH="$DATA_PATH:/app/data"
ENV_FILE=".env"

echo -e "${BOLD}======================================${RESET}"
echo -e "${CYAN}📦 Deploy script for${RESET} ${BOLD}$IMAGE_NAME${RESET}"
echo -e "${CYAN}Dry run mode:${RESET} $DRY_RUN"
echo -e "${CYAN}📂 Using data path:${RESET} $DATA_PATH"
echo -e "${BOLD}======================================${RESET}"

# Detect container engine
ENGINE=""

if command -v podman >/dev/null 2>&1 && command -v docker >/dev/null 2>&1; then
  warn "Both Podman and Docker detected."
  echo -e "${CYAN}Choose container engine:${RESET}"
  select choice in "podman" "docker"; do
    ENGINE=$choice
    break
  done
elif command -v podman >/dev/null 2>&1; then
  ENGINE="podman"
  info "Podman detected."
elif command -v docker >/dev/null 2>&1; then
  ENGINE="docker"
  info "Docker detected."
else
  error "Neither Docker nor Podman is installed."
  exit 1
fi

info "Using container engine: ${BOLD}$ENGINE${RESET}"
echo ""

run_cmd() {
  if $DRY_RUN; then
    echo -e "${YELLOW}> $*${RESET}"
  else
    eval "$@"
  fi
}

info "Stopping existing container..."
run_cmd "$ENGINE stop $CONTAINER_NAME || true"

info "Removing existing container..."
run_cmd "$ENGINE rm $CONTAINER_NAME || true"

info "Building new image..."
run_cmd "$ENGINE build -t $IMAGE_NAME ."

info "Starting new container..."
run_cmd "$ENGINE run -d --name $CONTAINER_NAME -p $PORT -v $VOLUME_PATH --env-file $ENV_FILE $IMAGE_NAME"

success "Done!"

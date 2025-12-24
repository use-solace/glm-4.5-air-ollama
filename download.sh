#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

HF_REPO="unsloth/GLM-4.5-Air-GGUF"
HF_PATTERN="*IQ1_M*.gguf"
MODEL_NAME="GLM-4.5-Air-UD-IQ1_M.gguf"
DEST_DIR="$HOME/glm-4.5-air-model"
MIN_FREE_GB=60

error() {
  echo "✳︎ ERROR: $1" >&2
  exit 1
}

info() {
  echo "▶ $1"
}

info "Running preflight checks..."

command -v huggingface-cli >/dev/null 2>&1 \
  || error "huggingface-cli not found in PATH"

FREE_GB=$(df -Pk "$HOME" | awk 'NR==2 {printf "%.0f\n", $4/1024/1024}')
[[ "$FREE_GB" -ge "$MIN_FREE_GB" ]] \
  || error "Insufficient disk space: ${FREE_GB}GB free, need at least ${MIN_FREE_GB}GB"

info "Disk space OK (${FREE_GB}GB free)"

info "Preparing destination directory..."
mkdir -p "$DEST_DIR" || error "Failed to create $DEST_DIR"

DEST_FILE="$DEST_DIR/$MODEL_NAME"

[[ ! -e "$DEST_FILE" ]] \
  || error "Destination file already exists: $DEST_FILE"

info "Downloading GLM-4.5-Air IQ1_M directly to destination..."

huggingface-cli download "$HF_REPO" \
  --include "$HF_PATTERN" \
  --local-dir "$DEST_DIR" \
  --local-dir-use-symlinks False \
  || error "huggingface-cli download failed"

info "Verifying downloaded file..."

[[ -f "$DEST_FILE" ]] \
  || error "Expected file not found: $DEST_FILE"

[[ -s "$DEST_FILE" ]] \
  || error "Downloaded file is empty"

FILE_SIZE=$(stat -f%z "$DEST_FILE")

info "Download verified (${FILE_SIZE} bytes)"
echo "⁂ GLM-4.5-Air IQ1_M successfully installed"
echo "→ Location: $DEST_FILE"

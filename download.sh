#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

HF_REPO="unsloth/GLM-4.5-Air-GGUF"
HF_PATTERN="*IQ1_M*gguf"
MODEL_NAME="GLM-4.5-Air-UD-IQ1_M.gguf"
HF_CACHE="$HOME/.cache/huggingface/hub"
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

command -v df >/dev/null 2>&1 \
  || error "df command not available"

FREE_GB=$(df -Pk "$HOME" | awk 'NR==2 {printf "%.0f\n", $4/1024/1024}')
[[ "$FREE_GB" -ge "$MIN_FREE_GB" ]] \
  || error "Insufficient disk space: ${FREE_GB}GB free, need at least ${MIN_FREE_GB}GB"

info "Disk space OK (${FREE_GB}GB free)"

info "Downloading GLM-4.5-Air IQ1_M from Hugging Face..."

huggingface-cli download "$HF_REPO" --include "$HF_PATTERN" \
  || error "huggingface-cli download failed"

info "Locating downloaded GGUF file..."

FOUND_FILES=()
while IFS= read -r file; do
  FOUND_FILES+=("$file")
done < <(find "$HF_CACHE" -type f -name "$MODEL_NAME" 2>/dev/null)

[[ "${#FOUND_FILES[@]}" -eq 1 ]] \
  || error "Expected exactly 1 GGUF file, found ${#FOUND_FILES[@]}"

SRC_FILE="${FOUND_FILES[0]}"

[[ -s "$SRC_FILE" ]] \
  || error "Downloaded file exists but is empty"

info "Found GGUF at:"
info "  $SRC_FILE"

info "Preparing destination directory..."

mkdir -p "$DEST_DIR" \
  || error "Failed to create destination directory: $DEST_DIR"

DEST_FILE="$DEST_DIR/$MODEL_NAME"

if [[ -e "$DEST_FILE" ]]; then
  error "Destination file already exists: $DEST_FILE (refusing to overwrite)"
fi

info "Copying GGUF to destination..."

cp "$SRC_FILE" "$DEST_FILE" \
  || error "File copy failed"

sync

[[ -s "$DEST_FILE" ]] \
  || error "Copied file is empty"

SRC_SIZE=$(stat -f%z "$SRC_FILE")
DEST_SIZE=$(stat -f%z "$DEST_FILE")

[[ "$SRC_SIZE" -eq "$DEST_SIZE" ]] \
  || error "File size mismatch after copy"

info "Copy verified (${DEST_SIZE} bytes)"

echo "⁂ GLM-4.5-Air IQ1_M successfully downloaded and installed"
echo "→ Location: $DEST_FILE"

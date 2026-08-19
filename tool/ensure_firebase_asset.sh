#!/usr/bin/env bash
set -euo pipefail

DEST="assets/google-services.json"
PLACEHOLDER="assets/google-services.placeholder.json"

if [[ -n "${FIREBASE_SERVICE_ACCOUNT:-}" ]]; then
  printf '%s' "$FIREBASE_SERVICE_ACCOUNT" > "$DEST"
  echo "Wrote $DEST from FIREBASE_SERVICE_ACCOUNT"
elif [[ -f "$DEST" ]]; then
  echo "Using existing $DEST"
elif [[ -f "$PLACEHOLDER" ]]; then
  cp "$PLACEHOLDER" "$DEST"
  echo "Copied $PLACEHOLDER to $DEST"
else
  echo "Missing $DEST and $PLACEHOLDER"
  exit 1
fi

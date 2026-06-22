#!/usr/bin/env bash
set -eo pipefail

INSTALL_DIR="${1:-$HOME/.local/bin}"

mkdir -p "$INSTALL_DIR"
cp errorz "$INSTALL_DIR/errorz"
chmod +x "$INSTALL_DIR/errorz"

echo "Installed errorz to $INSTALL_DIR/errorz"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Note: $INSTALL_DIR is not in your PATH."
    echo "Add it with: export PATH=\"$INSTALL_DIR:\$PATH\""
fi

#!/usr/bin/env bash
set -eo pipefail

INSTALL_DIR="${1:-$HOME/.local/bin}"

mkdir -p "$INSTALL_DIR"
cp httpz "$INSTALL_DIR/httpz"
chmod +x "$INSTALL_DIR/httpz"

echo "Installed httpz to $INSTALL_DIR/httpz"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Note: $INSTALL_DIR is not in your PATH."
    echo "Add it with: export PATH=\"$INSTALL_DIR:\$PATH\""
fi

#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wk"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[info]${NC}  $*"; }
done_() { echo -e "${GREEN}[done]${NC}  $*"; }

echo -e "${BOLD}Installing wk - Niri Worktree Manager${NC}"
echo ""

# Install scripts
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/wk" "$SCRIPT_DIR/dev" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/wk" "$INSTALL_DIR/dev"
done_ "Installed scripts to $INSTALL_DIR/"

# Create config
mkdir -p "$CONFIG_DIR"
if [[ ! -f "$CONFIG_DIR/wk.conf" ]]; then
    cp "$SCRIPT_DIR/wk.conf.example" "$CONFIG_DIR/wk.conf"
    done_ "Created config at $CONFIG_DIR/wk.conf"
    info "Edit it to set your MAIN_REPO path"
else
    info "Config already exists at $CONFIG_DIR/wk.conf"
fi

echo ""

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    info "Add ${BOLD}$INSTALL_DIR${NC} to your PATH if it isn't already:"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

done_ "Installation complete! Run ${BOLD}wk init${NC} to configure."

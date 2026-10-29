#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.pre-arlo-linux-dev"

# 1. zsh must be installed
if ! command -v zsh >/dev/null 2>&1; then
    echo "error: zsh is not installed (try: sudo apt install zsh)" >&2
    exit 1
fi

# 2. install oh-my-zsh if needed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh"
    # --unattended: don't chsh or start zsh; KEEP_ZSHRC: leave ~/.zshrc for the step below
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. nothing to do if ~/.zshrc already links to the zshrc in this repo
if [ -L "$ZSHRC" ] && [ "$(readlink "$ZSHRC")" = "$REPO_DIR/zshrc" ]; then
    echo "Link already exists:"
    ls -l "$ZSHRC"
else
    # 4. move aside the existing ~/.zshrc
    if [ -L "$ZSHRC" ]; then
        echo "Removing existing symlink:"
        ls -l "$ZSHRC"
        rm "$ZSHRC"
    elif [ -f "$ZSHRC" ]; then
        echo "Moving $ZSHRC to $BACKUP"
        mv "$ZSHRC" "$BACKUP"
    fi

    # 5. link to the zshrc in this repo
    ln -s "$REPO_DIR/zshrc" "$ZSHRC"
    ls -l "$ZSHRC"
fi

# 6. build the Rust tools (zshrc falls back to path_filter.py without them)
if command -v cargo >/dev/null 2>&1; then
    echo "Building Rust tools"
    cargo build --release --manifest-path "$REPO_DIR/tools/Cargo.toml"
else
    echo "cargo not found; skipping Rust tools build (see https://rustup.rs)"
fi

echo "Done. Open a new terminal or run: exec zsh"

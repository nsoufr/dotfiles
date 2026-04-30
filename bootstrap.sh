#!/usr/bin/env bash

set -e

cd "$HOME"

DOTFILES_DIR="$HOME/dev/personal/dotfiles"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "$machine" = "Mac" ]; then
    if ! command -v brew &>/dev/null; then
        echo 'Installing brew'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo 'Installing required packages'
    brew install zsh tmux
fi

if [ "$machine" = "Linux" ]; then
    echo 'Installing required packages'
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y zsh git tmux
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y zsh git tmux
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zsh git tmux
    else
        echo "Warning: could not detect package manager, skipping package install"
    fi

    # keyd: CapsLock = Ctrl (held) / Escape (tapped) — works on X11 and Wayland
    # Not in all distro repos, so build from source if not already installed
    if ! command -v keyd &>/dev/null; then
        echo 'Installing build tools and building keyd from source'
        if command -v apt-get &>/dev/null; then
            sudo apt-get install -y gcc make
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y gcc make
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm gcc make
        fi
        KEYD_TMP=$(mktemp -d)
        git clone https://github.com/rvaiya/keyd "$KEYD_TMP/keyd"
        make -C "$KEYD_TMP/keyd"
        sudo make -C "$KEYD_TMP/keyd" install
        rm -rf "$KEYD_TMP"
    fi

    sudo mkdir -p /etc/keyd
    sudo cp "$DOTFILES_DIR/keyd/default.conf" /etc/keyd/default.conf
    sudo systemctl enable --now keyd
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo 'Installing oh my zsh'
    ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo 'oh-my-zsh already installed, skipping'
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo 'Installing powerlevel10k'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo 'powerlevel10k already installed, skipping'
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning nandosousafr/dotfiles..."
    mkdir -p "$HOME/dev/personal"
    git clone https://github.com/nandosousafr/dotfiles.git "$DOTFILES_DIR"
else
    echo 'dotfiles already cloned, skipping'
fi

echo "Setting up global git config"
ln -sf "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
git config --global core.excludesfile ~/.gitignore_global

echo 'Setting up zsh config'
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo 'Setting up tmux config'
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo 'Setting up p10k config'
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

echo 'Done! Open a new shell or run: exec zsh'

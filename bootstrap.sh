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

# The repo must be cloned BEFORE the platform blocks: the Linux branch installs
# keyd's config from $DOTFILES_DIR, and on a fresh machine that path does not
# exist yet. git is a hard prerequisite for this step.
if ! command -v git &>/dev/null; then
    echo 'Installing git'
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y git
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y git
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm git
    elif command -v xcode-select &>/dev/null; then
        xcode-select --install || true
    fi
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning nsoufr/dotfiles..."
    mkdir -p "$HOME/dev/personal"
    git clone https://github.com/nsoufr/dotfiles.git "$DOTFILES_DIR"
else
    echo 'dotfiles already cloned, skipping'
fi

if [ "$machine" = "Mac" ]; then
    if ! command -v brew &>/dev/null; then
        echo 'Installing brew'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo 'Installing required packages'
    brew install zsh tmux neovim ripgrep

    echo
    echo 'NOTE: CapsLock -> Ctrl cannot be set from a script on macOS.'
    echo 'Set it manually in System Settings > Keyboard >'
    echo 'Keyboard Shortcuts > Modifier Keys > Caps Lock > Control'
    echo
fi

if [ "$machine" = "Linux" ]; then
    echo 'Installing required packages'
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y zsh git tmux neovim ripgrep
    elif command -v dnf &>/dev/null; then
        # Fedora / RHEL / Rocky. All five are in the default repos.
        sudo dnf install -y zsh git tmux neovim ripgrep
    elif command -v rpm-ostree &>/dev/null; then
        # Fedora Silverblue / Kinoite / other atomic desktops have no dnf.
        echo 'Atomic Fedora detected — layering packages with rpm-ostree.'
        echo 'A reboot is required before the layered packages are usable.'
        sudo rpm-ostree install -y --idempotent zsh git tmux neovim ripgrep
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zsh git tmux neovim ripgrep
    else
        echo "Warning: could not detect package manager, skipping package install"
    fi

    # keyd: CapsLock = Ctrl (held) / Escape (tapped) — works on X11 and Wayland.
    # Not packaged in Fedora's official repos (only a third-party COPR), so we
    # build from source rather than depend on an untrusted overlay.
    if ! command -v keyd &>/dev/null; then
        echo 'Installing build tools and building keyd from source'
        if command -v apt-get &>/dev/null; then
            sudo apt-get install -y gcc make linux-libc-dev
        elif command -v dnf &>/dev/null; then
            # kernel-headers provides <linux/input.h>, which keyd needs to build.
            sudo dnf install -y gcc make kernel-headers
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm gcc make linux-api-headers
        fi
        KEYD_TMP=$(mktemp -d)
        git clone https://github.com/rvaiya/keyd "$KEYD_TMP/keyd"
        make -C "$KEYD_TMP/keyd"
        sudo make -C "$KEYD_TMP/keyd" install
        rm -rf "$KEYD_TMP"
    fi

    if [ -f "$DOTFILES_DIR/keyd/default.conf" ]; then
        sudo mkdir -p /etc/keyd
        sudo cp "$DOTFILES_DIR/keyd/default.conf" /etc/keyd/default.conf
    else
        echo "Warning: $DOTFILES_DIR/keyd/default.conf not found, skipping keyd config"
    fi

    # Containers, WSL1 and chroots have no running systemd; don't abort there.
    if command -v systemctl &>/dev/null && [ -d /run/systemd/system ]; then
        # make install drops a new unit file, so reload before enabling it.
        sudo systemctl daemon-reload
        sudo systemctl enable --now keyd
    else
        echo 'systemd not running — skipping keyd service enable.'
        echo 'Start it manually later with: sudo systemctl enable --now keyd'
    fi
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo 'Installing oh my zsh'
    # Pass ZSH explicitly so the install target matches the -d guard above.
    # It used to be `ZSH= ` (empty), which only worked because the installer
    # happens to use ${ZSH:-default} rather than ${ZSH-default}.
    # </dev/null keeps the installer off this script's stdin, which is the
    # pipe feeding bootstrap.sh under the usual `curl ... | bash`.
    # --keep-zshrc: never let the installer write its own ~/.zshrc template.
    # Ours is a symlink to the repo and the installer would otherwise back it up
    # and replace it (order-independent safety, not just relying on the symlink
    # step below running afterwards).
    ZSH="$HOME/.oh-my-zsh" sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended --keep-zshrc </dev/null
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

# Symlink a repo file into place. If the destination is already the right
# symlink, repoint it silently. If it's an existing real file/dir (e.g. a
# hand-made config on a fresh machine), back it up before replacing so a first
# run never silently discards local edits.
link() {
    src="$1"; dst="$2"
    if [ -L "$dst" ]; then
        ln -sfn "$src" "$dst"
    elif [ -e "$dst" ]; then
        backup="$dst.pre-dotfiles.$(date +%Y%m%d-%H%M%S)"
        echo "  backing up existing $dst -> $backup"
        mv "$dst" "$backup"
        ln -s "$src" "$dst"
    else
        ln -s "$src" "$dst"
    fi
}

echo "Setting up global git config"
link "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
git config --global core.excludesfile ~/.gitignore_global

echo 'Setting up zsh config'
link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo 'Setting up tmux config'
link "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo 'Setting up p10k config'
link "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

echo 'Setting up nvim config'
mkdir -p "$HOME/.config"
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# oh-my-zsh is installed with --unattended, which deliberately skips chsh.
# Don't call chsh here either: it prompts for a password, which would hang the
# common `curl ... | bash` invocation. Just tell the user.
ZSH_PATH="$(command -v zsh || true)"
if [ -n "$ZSH_PATH" ] && [ "${SHELL:-}" != "$ZSH_PATH" ]; then
    echo
    echo "NOTE: your login shell is still ${SHELL:-unknown}."
    echo "Make zsh the default with:  chsh -s $ZSH_PATH"
    if [ "$machine" = "Linux" ] && ! grep -qxF "$ZSH_PATH" /etc/shells 2>/dev/null; then
        echo "(first: echo $ZSH_PATH | sudo tee -a /etc/shells)"
    fi
    echo
fi

echo 'Done! Open a new shell or run: exec zsh'

#!/usr/bin/env bash

cd "$HOME"

echo 'Installing required packages'
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update -y
sudo apt-get install -y neovim zsh tmux xclip

echo 'Install neovim dependencies'
sudo apt-get install -y ripgrep fzf

echo 'Installing oh my zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Cloning nandosousafr/dotfiles..."
git clone https://github.com/nandosousafr/dotfiles.git

echo "Setting up global git config"
ln -s dotfiles/.gitignore_global .gitignore_global
git config --global core.excludesfile ~/.gitignore_global

echo 'Setting up zsh config'
rm ~/.zshrc && ln -s dotfiles/.zshrc .zshrc

echo 'Setting up Tmux'
ln -s dotfiles/.tmux.conf .tmux.conf

echo 'Setting up Neovim'
mkdir -p $HOME/.config && rm -rf $HOME/.config/nvim
ln -s $HOME/dotfiles/.config/nvim $HOME/.config/nvim

echo 'Installing vim plug'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo 'Fix for telescope-fzf-native error'
# https://stackoverflow.com/questions/77435038/what-did-i-do-wrong-with-my-neovim-telescope-config
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make && cd -

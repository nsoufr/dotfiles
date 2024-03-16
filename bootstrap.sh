#!/usr/bin/env bash

cd "$HOME";

echo 'Installing required packages'
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim zsh tmux xclip

echo 'Installing oh my zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Cloning nandosousafr/dotfiles...";
git clone https://github.com/nandosousafr/dotfiles.git

echo "Setting up global git config";
ln -s dotfiles/.gitignore_global .gitignore_global
git config --global core.excludesfile ~/.gitignore_global

echo 'Setting up zsh config';
rm ~/.zshrc && ln -s dotfiles/.zshrc .zshrc

echo 'Setting up Tmux';
ln -s dotfiles/.tmux.conf .tmux.conf

echo 'Setting up Neovim';
mkdir -p $HOME/.config/nvim
ln -s dotfiles/init.vim .config/nvim/init.vim

echo 'Installing vim plug';
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


nvim --headless --cmd "call mkdir(stdpath('config'), 'p')" +q
nvim --headless --cmd "'edit '.stdpath('config').'/init.vim'" +q
nvim --headless +PlugInstall +q

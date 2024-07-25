#!/usr/bin/env bash

cd "$HOME"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ $machine == "Mac" ]; then
       echo 'Installing brew'
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       echo 'Installing required packages'
       brew install zsh
fi

if [ $machine == "Linux" ]; then
       echo 'Installing required packages'
       sudo apt-get update -y
       sudo apt-get install -y zsh
fi


echo 'Installing oh my zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Cloning nandosousafr/dotfiles..."
git clone https://github.com/nandosousafr/dotfiles.git

echo "Setting up global git config"
ln -s dotfiles/.gitignore_global .gitignore_global
git config --global core.excludesfile ~/.gitignore_global

echo 'Setting up zsh config'
rm ~/.zshrc && ln -s dotfiles/.zshrc .zshrc
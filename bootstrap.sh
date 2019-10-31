#!/usr/bin/env bash

cd "$HOME";

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ $machine == "Linux" ]; then
	echo "Linux detected, installing dependencies"
	sudo apt-get install git-core vim ctags zsh vim-gnome tmux xclip
fi

# General settings
git config --global core.editor /usr/bin/vim

echo "Cloning nandosousafr/dotfiles..."
git clone https://github.com/nandosousafr/dotfiles.git;

echo "Setting up...";
ln -s dotfiles/dotvim .vim;
ln -s dotfiles/vimrc .vimrc;
ln -s dotfiles/.gitignore_global .gitignore_global;

git config --global core.excludesfile ~/.gitignore_global;


if [ $machine == "Linux" ]; then
	ln -s dotfiles/.tmux.conf .tmux.conf;
elif [ $machine == "Mac" ]; then
	ln -s dotfiles/.mac-osx-tmux.conf .tmux.conf;
fi


echo "Fetching neobundle...";

curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh;

echo "Installing vim plugins";
vim +NeoBundleInstall +qall

#!/usr/bin/env bash

cd "$HOME";

echo "Cloning nandosousafr/dotfiles..."
git clone https://github.com/nandosousafr/dotfiles.git;

echo "Setting up...";
mv .vim vim-backup
ln -s dotfiles/dotvim .vim;
ln -s dotfiles/vimrc .vimrc;

echo "Fetching neobundle...";

curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh;

echo "Installing vim plugins";
vim +NeoBundleInstall +qall

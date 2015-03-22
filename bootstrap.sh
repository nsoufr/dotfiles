#!/usr/bin/env bash

cd "$(dirname "${HOME}")";

git clone https://github.com/nandosousafr/dotfiles.git;

function doIt() {
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

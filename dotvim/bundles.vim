set nocompatible
filetype off

if !1 | finish | endif

if has('vim_starting')
   if &compatible
     set nocompatible               " Be iMproved
   endif

   " Required:
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Plugin manager
NeoBundleFetch 'Shougo/neobundle.vim'

" General
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'greplace.vim'
NeoBundle 'Indent-Guides'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/syntastic'        " Syntax checking on save
NeoBundle 'taglist.vim'                 " Tag list navigation
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'rking/ag.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'tpope/vim-fugitive'


" Custom textobjects
NeoBundle 'kana/vim-textobj-user.git'
NeoBundle 'kana/vim-textobj-entire.git'
NeoBundle 'kana/vim-textobj-indent.git'
NeoBundle 'kana/vim-textobj-syntax.git'
NeoBundle 'kana/vim-textobj-line.git'

" Syntax support
NeoBundle 'vim-scripts/c.vim'
NeoBundle 'lambdatoast/elm.vim'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'cakebaker/scss-syntax.vim'

" Colorschemes
NeoBundle 'romainl/Apprentice'
NeoBundle 'dracula/vim'
NeoBundle'wolf-dog/nighted.vim'

" Tools
NeoBundle 'godlygeek/tabular'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'christoomey/vim-tmux-runner'
NeoBundle 'scrooloose/nerdtree'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

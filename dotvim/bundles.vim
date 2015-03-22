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
NeoBundle 'bling/vim-airline'
NeoBundle 'Indent-Guides'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'AutoComplPop'                " Autocomplete
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'tpope/vim-fugitive'          " Git integration
NeoBundle 'scrooloose/syntastic'        " Syntax checking on save
NeoBundle 'tpope/vim-dispatch'          " Async external commands with output in vim
NeoBundle 'taglist.vim'                 " Tag list navigation
NeoBundle 'kien/ctrlp.vim'

" Ruby
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'josemarluedke/vim-rspec'

" Syntax support
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-markdown'


" Colorschemes
NeoBundle 'altercation/vim-colors-solarized'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

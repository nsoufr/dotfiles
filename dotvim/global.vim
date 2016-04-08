source ~/.vim/bundles.vim " load plugins

syntax enable
set background=light
colorscheme heroku-terminal

" Set map
let mapleader = ","
let maplocalleader = "\\"

" presentation settings
set number              " precede each line with its line number
set numberwidth=3       " number of culumns for line numbers
set textwidth=0         " Do not wrap words (insert)
set nowrap              " Do not wrap words (view)
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ruler               " line and column number of the cursor position
set wildmenu            " enhanced command completion
set visualbell          " use visual bell instead of beeping
set laststatus=2        " always show the status line
set listchars=tab:▷⋅,trail:·,eol:$
set listchars=tab:▷⋅,trail:·
set list

" Do not create swap files
set noswapfile

" Copy support
set clipboard=unnamed

set backspace=indent,eol,start

source ~/.vim/plugins.vim

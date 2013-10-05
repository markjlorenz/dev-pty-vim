" vundle is perfect for /dev/pty/vim
" once all parties have joined the pairing session,
" just `:BundleInstall` and everyone can be using a
" shared set of plugins.

colorscheme vividchalk
set nocompatible
set nowritebackup
set noswapfile
set nobackup
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set indentexpr=
set number
set autoindent
set laststatus=2 " Always show the statusline

syntax enable
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
Bundle 'gmarik/vundle'
Bundle 'dapplebeforedawn/vim-ruby-buffer'
Bundle 'dapplebeforedawn/vim-shell-buffer'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-fugitive'
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'vim-scripts/tComment'
Bundle 'kchmck/vim-coffee-script'
Bundle 'csexton/trailertrash.vim'

filetype plugin indent on

cmap W w
cmap Q q
cmap Gs Gstatus
cmap Gc Gcommit
cmap Gw Gwrite

let mapleader = ","
map <Space> :CtrlP<cr>
map <leader>w :w<cr>
map <S-h> gT
map <S-l> gt

au BufWritePre * :Trim " for trailer trash

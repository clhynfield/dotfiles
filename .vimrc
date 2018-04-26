set nocompatible              " be iMproved, required
filetype off                  " required

" https://github.com/VundleVim/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Put your non-Plugin stuff after this line

set tabstop=4
set shiftwidth=4
set expandtab

autocmd BufNewFile,BufRead .envrc set syntax=sh

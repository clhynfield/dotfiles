#!/bin/sh

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [ -r '/etc/os-release' ]; then
    source '/etc/os-release'
fi

if [ "$ID" == 'debian' -o "$ID_LIKE" == 'debian' ]; then
    sudo apt-get install -y automake build-essential pkg-config libevent-dev libncurses5-dev
fi

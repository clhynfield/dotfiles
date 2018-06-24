#!/bin/sh

if [ -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

if [ -r '/etc/os-release' ]; then
    source '/etc/os-release'
fi

function with_privelege() {
    if [[ $EUID -ne 0 ]]; then
        sudo "$@"
    else
        "$@"
    fi
}

if [ "$ID" == 'debian' -o "$ID_LIKE" == 'debian' ]; then
    with_privelege apt-get update
    with_privelege apt-get install -y automake build-essential pkg-config libevent-dev libncurses5-dev
fi

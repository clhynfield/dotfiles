#!/bin/bash

if [ -r '/etc/os-release' ]; then
    source '/etc/os-release'
fi

function with_privilege() {
    if [[ $EUID -ne 0 ]]; then
        sudo "$@"
    else
        "$@"
    fi
}

if [ "$ID" == 'debian' ] || [ "$ID_LIKE" == 'debian' ]; then
    with_privilege apt-get update
    with_privilege apt-get install -y \
        sudo \
        automake \
        build-essential \
        pkg-config \
        libevent-dev \
        libncurses5-dev
fi

if [ "$OSTYPE" == 'darwin' ]; then # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

brew install getantibody/tap/antibody

brew install direnv

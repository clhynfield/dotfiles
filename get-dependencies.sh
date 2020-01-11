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

if [ "$OSTYPE" == 'darwin' ]; then
    brew install getantibody/tap/antibody
else
    curl -sL git.io/antibody | sh -s
fi

if [ "$OSTYPE" == 'darwin' ]; then
    brew install direnv
elif [ "$ID" == 'debian' ] || [ "$ID_LIKE" == 'debian' ]; then
    with_privilege apt-get install -y direnv
fi


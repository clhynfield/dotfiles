#!/bin/sh

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
    with_privelege apt-get install -y sudo automake build-essential pkg-config libevent-dev libncurses5-dev
fi

if [ $OSTYPE == 'darwin' ]; then
    brew install getantibody/tap/antibody
else
    curl -sL git.io/antibody | sh -s
fi

if [ $OSTYPE == 'darwin' ]; then
    brew install direnv
elif [ "$ID" == 'debian' -o "$ID_LIKE" == 'debian' ]; then
    with_privelege apt-get install -y direnv
fi


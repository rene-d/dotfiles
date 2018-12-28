#! /bin/bash

has_sudo=$(which sudo > /dev/null && echo 1)

# when run as root
if [ $(id -u) -eq 0 ]; then

    if [ $has_sudo ]; then
        echo "Should not be run as root"
        exit 2
    fi

    apt install sudo

    echo "$(id -nu 1000) ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    # adduser $(id -nu) sudo
    echo "Login as $(id -nu 1000) then rerun this script."
    exit 0
fi

if [ ! $has_sudo ]; then
    echo "sudo is required but not installed. Rerun the script as root."
    exit 2
fi

# nodejs
#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# debian and ubuntu have (almost?) the same packages
./ubuntu.sh

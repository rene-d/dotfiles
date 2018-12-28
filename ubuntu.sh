#! /bin/bash

# install script for Ubuntu 18.10 Cosmic Cuttlefish (ubuntu Budgie flavor)

echo "----------------------- Base -----------------------"

sudo apt update
sudo apt upgrade

sudo apt install -y \
    curl httpie htop lftp tree ncdu tmux \
    iperf3 wireshark tshark iftop \
    terminator meld \
    vim vim-addon-manager vim-fugitive vim-ctrlp \
    figlet toilet sl \
    git git-gui tig \
    build-essential gdb clang lldb valgrind cppcheck \
    cmake cmake-curses-gui cmake-doc \
    cscope cloc graphviz \
    libboost-all-dev \
    libzmq3-dev libczmq-dev \
    protobuf-c-compiler protobuf-compiler \
    nodejs npm
    
if [[ "$(uname -m)" == amd64 ]]; then
    sudo apt install -y \
        default-jdk maven

    sudo apt install -y \
        clang-7-doc libstdc++-8-doc \
        linux-tools-common linux-tools-generic
fi


echo "----------------------- Others -----------------------"

sudo gem install gist
# vim-addon-manager install fugitive

if [[ "$(sudo dmidecode -s bios-version)" == "VirtualBox" ]]; then
    sudo apt install virtualbox-guest-utils
fi


echo "----------------------- Python 3 -----------------------"

# system site-packages
sudo apt install -y \
    python3-pip python3-venv \
    python3-requests python3-requests-cache python3-yaml python3-toml python3-flake8 \
    python3-numpy python3-matplotlib python3-scipy \
    python3-zmq python3-protobuf python3-scapy \
    cython3

# create a virtualenv (with and without system site-packages)
v=$(python3 -c 'import sys; print("{0.major}.{0.minor}".format(sys.version_info))')
python3 -mvenv --system-site-packages $HOME/.venv/${v}
python3 -mvenv $HOME/.venv/${v}-raw
# to activate: source $HOME/.venv/3.x/bin/activate


if [[ "$(uname -m)" != arm* ]]; then
    echo "----------------------- Visual Studio Code -----------------------"

    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
    sudo install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code # or code-insiders

    # python3 -c 'import requests, yaml; print("\n".join("code --install-extension {}".format(i) for i in yaml.load(requests.get("https://raw.githubusercontent.com/rene-d/dotfiles/master/vscode-ext.yaml").content)["extensions"]))' | sh
    python3 -c 'import requests, yaml; print("\n".join("code --install-extension {}".format(i) for i in yaml.load(open("vscode-ext.yaml").read())["extensions"]))' | sh
    
    sudo apt install -y python3-rope
fi

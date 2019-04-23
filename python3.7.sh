#! /bin/bash

version=3.7.3

echo "----------------------- Python ${version} -----------------------"

wget -O /tmp/Python-${version}.tar.xz -nv -c https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz

sudo apt install -y \
    libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev \
    libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev

tar -C /tmp -xaf /tmp/Python-${version}.tar.xz
pushd /tmp/Python-${version}
# ./configure --enable-optimizations
./configure
make -j4
sudo make altinstall
popd

python3.7 -mvenv $HOME/.venv/3.7
VIRTUAL_ENV_DISABLE_PROMPT=1 source $HOME/.venv/3.7/bin/activate

# update pip
pip3 install -U pip

if [[ "$(cat -v /sys/firmware/devicetree/base/model 2>/dev/null)" =~ "Raspberry Pi"* ]]; then
    # the Pi isn't powerful enough to compile math libraries
    pip3 install -U -r requirements-pi.txt
else
    # install favorite packages
    pip3 install -U -r requirements.txt
fi

#! /bin/bash

echo "----------------------- Python 3.7 -----------------------"

wget -O /tmp/Python-3.7.1.tar.xz -nv -c https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tar.xz

sudo apt install -y \
    libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev \
    libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev

tar -C /tmp -xaf /tmp/Python-3.7.1.tar.xz
pushd /tmp/Python-3.7.1
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
    pip3 install -r requirements-pi.txt
else
    # install favorite packages
    pip3 install -r requirements.txt
fi

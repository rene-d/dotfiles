#! /bin/bash

# possible platforms: manylinux1_x86_64 win_amd64 macosx_10_10_x86_64

# wheel:
#   <name>-<version>-<implementation><python-version>-<api>-<platform>.whl
# <implementation><python-version> can be repeated (ex: py2.py3)
# <api> may be "none"
# <platform> can be "any"
# <platform> can be repeated (macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64)

# source only:
#   <name>-<version>.tar.gz

cat requirements.txt | xargs -n1 pip3 download --isolated -d pip -i https://pypi.org/simple \
    --python-version=37                 \
    --abi=cp37m                         \
    --platform=manylinux1_x86_64        \
    --implementation=cp                 \
    --only-binary=:all:

pip3 download --isolated -d pip -i https://pypi.org/simple \
    --python-version=37                 \
    --abi=cp37m                         \
    --platform=manylinux1_x86_64        \
    --implementation=cp                 \
    --no-deps                           \
    -r requirements.txt

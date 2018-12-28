# Configuration macOS

## Installation de [Homebrew](https://brew.sh)

````bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
````

## Installation Apps

[Fluor](https://github.com/Pyroh/Fluor)
[MacDown](https://macdown.uranusjr.com)
[Couleurs](https://couleursapp.com)

````bash
brew cask install fluor macdown couleurs
brew cask install filezilla wireshark
brew cask install xnviewmp
````

## Installation du reste

````bash
brew install cmake cscope python3 node cloc boost gcc ghc
brew install vim wget bash sqlite dos2unix htop watch
brew install gnu-tar httpie tig bash-completion bash
brew install macvim
brew install ffmpeg fdupes ncdu tree unrar p7zip lftp iperf3 xz
brew install pari
brew install graphviz
brew install gist
brew install toilet figlet jp2a sl
brew install libpst exiv2 youtube-dl
brew install zeromq czmq protobuf
brew install jq
````

## Installation packages Python3

````bash
pip3 install -U pip
pip3 install -U pyyaml requests requests-cache flake8 virtualenv
pip3 install -U numpy scipy matplotlib mpmath scikit-learn
pip3 install -U ipython jupyter cython numba
pip3 install -U pytest pytest-cov pytest-mock pytest-pythonpath coveralls
pip3 install -U zmq qrcode simplekml lxml scapy
````

Alt: Installation de scikit-learn branche `master`
````bash
pip3 install https://github.com/scikit-learn/scikit-learn/archive/master.zip
````

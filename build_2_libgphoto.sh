#!/bin/bash

if [[ ! -d "/usr/local/share/libgphoto2" ]]; then
    sudo apt-get  -qq -y install build-essential cmake llvm clang-4.0 lldb-4.0 gcc g++ cmake intltool automake autoconf autopoint gettext libtool
    sudo mkdir -p /usr/local/bin
    source _setup.sh
    git_clone_or_checkout 'https://github.com/gphoto/libgphoto2.git' "$build_path"
    sudo autoreconf --install --symlink
    sudo ./configure --prefix=/usr/local
    sudo make -j8
    sudo make install
    popd
fi

#!/bin/bash


if [[ ! -d "/usr/local/share/libgphoto2" ]]; then

    sudo apt-fast  -qq -y install build-essential cmake llvm clang-4.0 lldb-4.0 gcc g++ cmake intltool automake autoconf autopoint gettext libtool

    wget https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/.bash_functions_git -O bash_functions_git
    source bash_functions_git

    git_clone_or_checkout ' https://github.com/gphoto/libgphoto2.git' '$HOME/tmp/buld'
    sudo autoreconf --install --symlink
    ./configure --prefix=/usr/local
    sudo make -j8
    sudo make install
    popd
fi

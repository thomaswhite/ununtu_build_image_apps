#!/usr/bin/env bash

sudo apt-fast install build-essential libfontconfig1 mesa-common-dev libraw-dev  exiv2 zlib1g-dev  qt4-default libalglib-dev libboost-all-dev

pushd ${build_path:.}
wget -q https://github.com/jcelaya/hdrmerge/archive/v0.5.0.tar.gz
tar -xzf v0.5.0.tar.gz
cd hdrmerge-0.5.0
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=$HOME  -DLIBRAW_DECODER_FLATFIELD='' ..

# in file ImageIO.cpp in line 42 replace LIBRAW_DECODER_FLATFIELD with 0

sudo make install

popd
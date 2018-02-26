#!/usr/bin/env bash

sudo apt-fast -qq  -y install lynx

link=`lynx -dump -listonly https://www.sno.phy.queensu.ca/~phil/exiftool/ | grep Image-ExifTool.*gz`
dotPos=`expr index "$link" '.'`
url=${link:$dotPos}

pushd $build_path

achive_name="$(basename $url)"
tar="${achive_name%.*}"
dir="${tar%.*}"

# remove build directory and the previously downloaded archive
[[ -f $achive_name ]] && rm Image-ExifTool*.gz*
[[ -d $dir      ]]    && find "$dir" -delete

# download and unzip the
wget -q  $url
tar -xzf $achive_name

# build
pushd $dir
perl Makefile.PL
make
#make test
make install
popd

# delete the archive and the installation directory
[[ -f $achive_name ]] && rm Image-ExifTool*.gz*
find "$dir" -delete

popd

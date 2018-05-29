#!/usr/bin/env bash

source _setup.sh "Install latest ExifTools"

sudo apt-get -qq  -y install lynx

link=`lynx -dump -listonly https://www.sno.phy.queensu.ca/~phil/exiftool/ | grep Image-ExifTool.*gz`
dotPos=`expr index "$link" '.'`
url=${link:$dotPos}

achive_name="$(basename $url)"
tar="${achive_name%.*}"
dir="${tar%.*}"
ver=$(echo "$dir" | cut -d- -f3)

pushd $build_path

# remove build directory and the previously downloaded archive
[[ -f $achive_name ]] && rm Image-ExifTool*.gz*
[[ -d $dir         ]] && find "$dir" -delete

# download and unzip the
wget -q  $url
tar -xzf $achive_name

# build
pushd $dir
perl Makefile.PL
make
#make test
sudo make install
popd

# delete the archive and the installation directory
[[ -f $achive_name ]] && rm Image-ExifTool*.gz*
find "$dir" -delete
echo ----------------------------------------------------------
echo Currently installed ExifTool version is: `exiftool -ver`

popd

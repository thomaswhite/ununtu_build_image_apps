#!/usr/bin/env bash

sudo apt-fast -qq  -y install lynx

link=`lynx -dump -listonly https://www.sno.phy.queensu.ca/~phil/exiftool/ | grep Image-ExifTool.*gz`
dotPos=`expr index "$link" '.'`
url=${link:$dotPos}

achive_name="$(basename $url)"
tar="${achive_name%.*}"
dir="${tar%.*}"

[[ -f $achive_name ]] && rm Image-ExifTool*.gz*
[[ -d $dir      ]] && find "$dir" -delete

wget -q $url
tar -xzf $achive_name
[[ -f $achive_name ]] && rm Image-ExifTool*.gz*
pushd $dir
perl Makefile.PL
make
#make test
make install
popd
find "$dir" -delete

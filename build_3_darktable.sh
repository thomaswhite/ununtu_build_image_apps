#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

#libopenjpeg-dev
sudo apt-get  -qq -y install build-essential cmake llvm clang-4.0 lldb-4.0 gcc g++ cmake intltool xsltproc libgtk-3-dev libxml2-utils libxml2-dev liblensfun-dev librsvg2-dev libsqlite3-dev libcurl4-gnutls-dev libjpeg-dev libtiff5-dev liblcms2-dev libjson-glib-dev libexiv2-dev libpugixml-dev libgphoto2-dev libsoup2.4-dev libopenexr-dev libwebp-dev libflickcurl-dev  libsecret-1-dev libgraphicsmagick1-dev libcolord-dev libcolord-gtk-dev libcups2-dev libsdl1.2-dev libsdl-image1.2-dev libgl1-mesa-dev libosmgpsmap-1.0-dev default-jdk gnome-doc-utils libsaxon-java fop imagemagick docbook-xml docbook-xsl liblua5.2-0 liblua5.2-dev lua5.2 lua5.2-doc

source _setup.sh
# source build_libgphoto.sh # make sure libphoto is available before building darktable

git_clone_or_checkout 'https://github.com/darktable-org/darktable.git' $build_path
sudo ./build.sh --prefix /opt/darktable --build-type Release
sudo cmake --build "$build_path/darktable/build" --target install -- -j8

echo "To start the installed Darktable use /opt/darktable/bin/darktable"

# TODO add a menu shortcut
#/opt/darktable/bin/darktable


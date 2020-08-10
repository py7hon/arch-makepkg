#!/bin/bash

if [[ ! -z "$1" ]]; then
    cd "$1"
fi

echo "Running makepkg from $PWD"

pkg_deps=$(source ./PKGBUILD && echo ${makedepends[@]} ${depends[@]})
echo "Installing dependencies: $pkg_deps"
pacman -Syu --noconfirm $pkg_deps

chown -R builder "$PWD"

echo "Running makepkg"

# TODO: support extra flags

su --login builder --command='makepkg -fs'

echo "Running namcap"

namcap -i *.pkg.tar.xz

#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    capstone \
    fmt      \
    glfw     \
    libuv    \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini libdecor-mini

echo "Building PCSX-Redux..."
echo "---------------------------------------------------------------"
REPO="https://github.com/grumpycoders/pcsx-redux"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./pcsx-redux
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
mkdir -p ./AppDir/share/pcsx-redux/resources
mkdir -p ./AppDir/share/pcsx-redux/fonts
cd ./pcsx-redux
make -j$(nproc)
mv -v pcsx-redux ../AppDir/bin
mv -v i18n ../AppDir/share/pcsx-redux
mv -v third_party/noto/*.ttf third_party/noto/*.otf ../AppDir/share/pcsx-redux/fonts
wget -O ../AppDir/share/pcsx-redux/resources/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt

#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    capstone \
    ffmpeg \
    fmt  \
    glfw \
    libuv \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package pcsx-redux-git

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi

echo "Building PCSX-Redux..."
echo "---------------------------------------------------------------"
REPO="https://github.com/grumpycoders/pcsx-redux"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./pcsx-redux
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
mkdir -p ./AppDir/share/pcsx-redux/resources
cd ./pcsx-redux
make -j$(nproc)
mv -v pcsx-redux ../AppDir/bin
mv -v i18n ../AppDir/share/pcsx-redux
wget -O ../AppDir/share/pcsx-redux/resources/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt

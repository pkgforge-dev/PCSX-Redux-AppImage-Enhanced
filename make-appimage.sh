#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=https://raw.githubusercontent.com/grumpycoders/pcsx-redux/refs/heads/main/resources/pcsx-redux.desktop
export STARTUPWMCLASS=pcsx-redux
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/pcsx-redux

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage

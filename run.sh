#!/bin/sh

set -x

export HOMEBREW_CASK_OPTS="--no-quarantine"

echo "Set env variables..."
export NDK_ROOT=${ANDROID_SDK_ROOT}/ndk-bundle
echo "::set-env name=NDK_ROOT::$NDK_ROOT"
export NUM_CPU=`python -c 'import multiprocessing as mp; print(mp.cpu_count())'`
echo "::set-env name=NUM_CPU::$NUM_CPU"
set
mkdir -p bins/macos
mkdir -p logs/macos

echo "Install dependencies..."
brew update 
brew cask install android-ndk --no-c
export NDK_ROOT="$(brew --prefix)/share/android-ndk"
echo "::set-env name=NDK_ROOT::$NDK_ROOT"

echo "Run build..."
CXXFLAGS="-std=c++14" ./build-android.sh --boost=1.70.0 --arch=armeabi-v7a --with-libraries=atomic,system "${NDK_ROOT}"
#!/usr/bin/env zsh
# Debian/Ubuntu
# Install C/C++ development environment
# Should be run as root (or sudo)

set -e

# Whether to remove build/install cache to slim down the image size
: ${DEV_CPP_CACHE_REMOVE:=true}
# Where to install other build system, for example llvm
: ${DEV_CPP_INSTALL_PREFIX:=/opt}
# Whether to **build** newest llvm
: ${DEV_CPP_BUILD_LLVM:=0}

if [ $(id -u -n) != "root" ]; then
    echo "Please run this script as the root" >&2
    exit 1
fi

# Make sure indispensable packages have been installed
apt-get update
apt-get install build-essential make cmake gdb -y
apt-get install clang clang-tidy clang-format lldb lld -y
# TODO `lldb --version` bug
rm -rf /var/lib/apt/lists/*

if [[ $DEV_CPP_BUILD_LLVM != 1 ]]; then
    exit 0
fi

# If $INSTALL_LLVM = 1, build llvm
# https://llvm.org/docs/CMake.html
git clone --depth=1 https://github.com/llvm/llvm-project.git \
    $DEV_CPP_INSTALL_PREFIX/cellar/llvm-project
# mkdir -p $DEV_CPP_INSTALL_PREFIX/cellar/llvm-project/build
cd $DEV_CPP_INSTALL_PREFIX/cellar/llvm-project
cmake -S llvm -B build -G "Unix Makefiles" \
         -DLLVM_ENABLE_PROJECTS="clang;extra-tools;lldb;lld;clang-tools-extra" \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=$DEV_CPP_INSTALL_PREFIX/llvm
cmake --build build -j4
cmake --install build # Very very long...

# If $PATH doesn't contain `${DEV_CPP_INSTALL_PREFIX}/llvm/bin`
if [[ $PATH != *$DEV_CPP_INSTALL_PREFIX/llvm/bin* ]]; then
    add_path_cmd=$'\n''export PATH='"$DEV_CPP_INSTALL_PREFIX"'/llvm/bin:$PATH'
    echo -n $add_path_cmd | tee -a /etc/zsh/zshenv /etc/bash.bashrc
fi

if [ $DEV_CPP_CACHE_REMOVE = true ]; then
    rm -rf /opt/cellar/llvm-project
fi
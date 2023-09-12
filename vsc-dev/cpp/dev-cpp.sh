#!/usr/bin/env zsh
# Debian/Ubuntu
# Install C/C++ development environment
# Should be run as root (or sudo)

set -e

# Whether to remove build/install cache to slim down the image size
: ${DEV_CPP_CACHE_REMOVE:=true}
# Where to install other build system, for example llvm
: ${DEV_CPP_INSTALL_PREFIX:=/opt}

if [ $(id -u -n) != "root" ]; then
    echo "Please run this script as the root" >&2
    exit 1
fi

# Make sure indispensable packages have been installed
apt update
apt install build-essential make cmake gdb -y
rm -rf /var/lib/apt/lists/*

if [[ $INSTALL_LLVM != 1 ]]; then
    exit 0
fi

# If $INSTALL_LLVM = 1, install llvm
git clone --depth=1 https://github.com/llvm/llvm-project.git \
    $DEV_CPP_INSTALL_PREFIX/cellar/llvm-project
mkdir -p $DEV_CPP_INSTALL_PREFIX/cellar/llvm-project/build
cd $DEV_CPP_INSTALL_PREFIX/cellar/llvm-project/build
cmake -DLLVM_ENABLE_PROJECTS="clang;lldb;clang-tools-extra"\
         -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DEV_CPP_INSTALL_PREFIX/llvm \
         -G "Unix Makefiles" ../llvm
make install -j4 # Very very long...

# If $PATH doesn't contain `${DEV_CPP_INSTALL_PREFIX}/llvm/bin`
if [[ $PATH != *$DEV_CPP_INSTALL_PREFIX/llvm/bin* ]]; then
    add_path_cmd=$'\n''export PATH='"$DEV_CPP_INSTALL_PREFIX"'/llvm/bin:$PATH'
    echo -n $add_path_cmd | tee -a /etc/zsh/zshenv /etc/bash.bashrc
fi

if [ $DEV_CPP_CACHE_REMOVE = true ]; then
    rm -rf /opt/cellar/llvm-project
fi
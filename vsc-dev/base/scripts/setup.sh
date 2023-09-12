#!/usr/bin/env bash

# Debian/Ubuntu
# Package configuration setup, also install some necessary utitlies
set -e

# Update the apt source
sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g"\
         "/etc/apt/sources.list.d/debian.sources"
apt-get update && apt upgrade -y

apt-get install \
    zsh \
    sudo \
    less \
    man \
    -y && rm -rf /var/lib/apt/lists/*
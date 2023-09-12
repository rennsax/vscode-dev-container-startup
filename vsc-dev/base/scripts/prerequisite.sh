#!/usr/bin/env zsh
# Install some prerequisite package

set -e

if [ $(id -u -n) != "root" ]; then
    echo "Please run this script as root."
    exit 1
fi

deps=(
    git curl gnupg2
    neovim procps
    rsync zip tmux
)

usage() {
    echo "Usage: $0 [-v]" >&2
}

while getopts "vh" arg; do
    case "$arg" in
    v)
        echo "Verbose mode enabled."
        is_verbose=1
        ;;
    h | *)
        usage
        exit 0
        ;;
    esac
done
shift $((OPTIND-1))
unset arg

if [ -z "$is_verbose" ]; then
    _eval() {
        eval $@ &> /dev/null
    }
else
    _eval() {
        eval $@
    }
fi

apt update
for dep ($deps); do
    if _eval apt install $dep -y; then
        echo "$dep successfully installed"
    else
        echo "Failed when installing $dep"
        exit 1
    fi
done
rm -rf /var/lib/apt/lists/*
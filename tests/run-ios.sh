#!/bin/sh

arch=arm64

remote_host=root@127.0.0.1
port_number=2222
remote_prefix=/usr/local/opt/frida-tests-$arch

gum_tests=$(dirname "$0")
cd "$gum_tests/../../build/tmp-ios-$arch/frida-gum" || exit 1
. ../../frida-meson-env-macos-x86_64.rc
ninja || exit 1
cd tests
ssh -p $port_number "$remote_host" "mkdir -p '$remote_prefix'"
rsync -rLz -e "ssh -p $port_number" gum-tests data "$remote_host:$remote_prefix/" || exit 1
ssh -p $port_number "$remote_host" "$remote_prefix/gum-tests" "$@"

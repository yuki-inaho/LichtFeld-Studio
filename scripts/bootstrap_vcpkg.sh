#!/bin/sh
set -eu

vcpkg_root=".pixi/vcpkg"

if [ ! -x "$vcpkg_root/vcpkg" ]; then
    git clone https://github.com/microsoft/vcpkg.git "$vcpkg_root"
    "$vcpkg_root/bootstrap-vcpkg.sh" -disableMetrics
fi

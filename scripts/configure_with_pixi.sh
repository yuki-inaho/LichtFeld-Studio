#!/bin/sh
set -eu

: "${PIXI_PROJECT_ROOT:?Run this script through pixi.}"
: "${CONDA_PREFIX:?Run this script through pixi.}"
: "${CXX:?Pixi C++ compiler is not configured.}"

export VCPKG_ROOT="$PIXI_PROJECT_ROOT/.pixi/vcpkg"
export PKG_CONFIG_PATH="$PIXI_PROJECT_ROOT/build/dev-release/vcpkg_installed/x64-linux/lib/pkgconfig:$PIXI_PROJECT_ROOT/cmake/pkgconfig:$CONDA_PREFIX/lib/pkgconfig:$CONDA_PREFIX/share/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export PKG_CONFIG="$CONDA_PREFIX/bin/pkg-config"
export AS="$CONDA_PREFIX/bin/nasm"

# conda-forge's GLib metadata refers to this generated-header directory even
# when the prebuilt package does not ship any generated headers there.
mkdir -p "$CONDA_PREFIX/lib/glib-2.0/include"
cmake -E copy_if_different \
    "$PIXI_PROJECT_ROOT/cmake/pkgconfig/glibconfig.h" \
    "$CONDA_PREFIX/lib/glib-2.0/include/glibconfig.h"

cmake --fresh --preset dev-release \
    -DCMAKE_CUDA_HOST_COMPILER="$CXX" \
    -DPKG_CONFIG_EXECUTABLE="$CONDA_PREFIX/bin/pkg-config" \
    -DLFS_PKG_CONFIG_EXECUTABLE="$CONDA_PREFIX/bin/pkg-config" \
    -DWITH_DYNAMIC_NVJPEG=ON

#!/bin/sh
set -eu

: "${PIXI_PROJECT_ROOT:?Run this script through pixi.}"
: "${CONDA_PREFIX:?Run this script through pixi.}"

# vcpkg shader tools require the newer libstdc++ shipped by Pixi.  Keep the
# project and its build-time tools on one runtime search path.
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$CONDA_PREFIX/targets/x86_64-linux/lib:$PIXI_PROJECT_ROOT/build/dev-release/vcpkg_installed/x64-linux/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

cmake --build --preset dev-release

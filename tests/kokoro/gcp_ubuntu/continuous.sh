#!/bin/bash

# Fail on any error.
set -e
# Display commands being run.
set -x

cd git/SwiftShader

git submodule update --init

mkdir -p build && cd build

if [[ -z "${REACTOR_BACKEND}" ]]; then
  REACTOR_BACKEND="LLVM"
fi

cmake .. "-DREACTOR_BACKEND=${REACTOR_BACKEND}"
make --jobs=$(nproc)

# Run the reactor unit tests.
./ReactorUnitTests

cd .. # Tests must be run from project root

# Run the OpenGL ES and Vulkan unit tests.
build/gles-unittests
build/vk-unittests

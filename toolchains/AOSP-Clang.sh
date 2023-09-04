#!/bin/bash

maindir="$(pwd)"
outside="${maindir}/.."

clang="${outside}/aosp_clang"
gcc64="${outside}/aosp_gcc64"
gcc="${outside}/aosp_gcc"

case $1 in
    "setup" )
      # Clone compiler
      if [ ! -d $clang ]; then
        git clone --depth=1 https://github.com/TeraaBytee/google-clang $clang
      fi
      if [ ! -d $gcc64 ]; then
        git clone --depth=1 https://github.com/TeraaBytee/aarch64-linux-android-4.9 $gcc64
      fi
      if [ ! -d $gcc ]; then
        git clone --depth=1 https://github.com/TeraaBytee/arm-linux-androideabi-4.9 $gcc
      fi
    ;;

    "build" )
        make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 $2
        make -j$(nproc --all) O=out \
            PATH="$clang/bin:$gcc64/bin:$gcc/bin:/usr/bin:${PATH}" \
            CROSS_COMPILE="aarch64-linux-android-" \
            CROSS_COMPILE_ARM32="arm-linux-androideabi-" \
            CLANG_TRIPLE="aarch64-linux-gnu-" \
            LD_LIBRARY_PATH="$clang/lib64:$LD_LIBRABRY_PATH" \
            CC=clang \
            LD=ld.lld \
            2>&1 | tee ${CUR_TOOLCHAIN}.log
    ;;
esac
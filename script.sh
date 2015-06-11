#!/usr/bin/env bash

MASON_NAME=gtest
MASON_VERSION=1.7.0
MASON_LIB_FILE=lib/libgtest.a

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    mason_download \
        https://googletest.googlecode.com/files/gtest-1.7.0.zip \
        86f5fd0ce20ef1283092d1d5a4bc004916521aaf


    mason_setup_build_dir
    unzip ../.cache/${MASON_SLUG}

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/gtest-1.7.0
}

function mason_compile {
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking

    make -j${MASON_CONCURRENCY}

    mkdir -p ${MASON_PREFIX}/lib
    cp -v lib/.libs/libgtest.a ${MASON_PREFIX}/lib
    mkdir -p ${MASON_PREFIX}/include/gtest
    cp -v fused-src/gtest/gtest.h ${MASON_PREFIX}/include/gtest
}

function mason_cflags {
    echo -isystem ${MASON_PREFIX}/include -I${MASON_PREFIX}/include
}

function mason_ldflags {
    echo -lpthread
}

function mason_static_libs {
    echo ${MASON_PREFIX}/lib/libgtest.a
}


mason_run "$@"

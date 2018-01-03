#!/bin/bash
#
# Copyright 2018, alex at staticlibs.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then

    # tools
    git submodule update --init --recursive deps/external_openssl
    git submodule update --init tools/gradle
    git submodule update --init tools/maven
    git submodule update --init tools/linux/jdk8
    git submodule update --init tools/android/android-ndk-r9d-arm-linux-androideabi-4.8
    git submodule update --init tools/android/sdk

    # env
    export PATH=`pwd`/tools/linux/jdk8/bin:$PATH
    export JAVA_HOME=`pwd`/tools/linux/jdk8
    export M2_HOME=`pwd`/tools/maven

    # build linux
    mkdir build
    pushd build
    cmake .. -DWILTON_BUILD_FLAVOUR=wheezy
    make
    make test_js > test_js.log
    make test_duktape > test_duktape.log
    make test_jvm > test_jvm.log
    make valgrind
    popd

    # build android
    mv build build-linux
    mkdir build
    pushd build
    cmake .. -DSTATICLIB_TOOLCHAIN=android_armeabi_gcc -DANDROID_SDK_ENABLE_LIBC_PRELOAD=OFF
    cp ../build-linux/std.wlib .
    make
    make android_jar > android_jar.log
    make android_apk
fi

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    set +e
    mkdir /Users/travis/build/staticlibs
    git clone https://github.com/staticlibs/tools_macos_openssl.git /Users/travis/build/staticlibs/tools_macos_openssl
    export PKG_CONFIG_PATH=/Users/travis/build/staticlibs/tools_macos_openssl/lib/pkgconfig:$PKG_CONFIG_PATH
    mkdir build
    pushd build
    set -e
    cmake ..
    make
    make test_js > test_js.log
    make test_duktape > test_duktape.log
fi

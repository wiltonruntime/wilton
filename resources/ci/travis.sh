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

if [ "xlinux" = "x${TRAVIS_OS_NAME}" ] ; then

    # tools
    git clone --quiet https://github.com/wilton-iot/tools_linux_jdk8.git ../jdk8
    git clone --quiet --recursive https://github.com/wilton-iot/android-tools-ci-repo.git ../android-tools
    git clone --quiet https://github.com/wilton-iot/arm-rpi-4.9.3-linux-gnueabihf.git ../arm-rpi-4.9.3-linux-gnueabihf

    # env
    export JAVA_HOME=`pwd`/../jdk8
    export M2_HOME=`pwd`/tools/maven
    export WILTON_ANDROID_TOOLS=`pwd`/../android-tools
    export WILTON_RPI_TOOLCHAIN=`pwd`/../arm-rpi-4.9.3-linux-gnueabihf/

    # android
    mkdir build
    pushd build
    if [ "x" = "x${TRAVIS_TAG}" ] ;  then
        cmake .. -DSTATICLIB_TOOLCHAIN=android_armeabi_gcc
    else
        cmake .. -DSTATICLIB_TOOLCHAIN=android_armeabi_gcc -DWILTON_RELEASE=${TRAVIS_TAG}
    fi
    make -j 2
    make android_apk > apk.log
    if [ "x" != "x${TRAVIS_TAG}" ] ;  then
        mv wilton_${TRAVIS_TAG}.apk ../
    fi
    popd

    # raspberry
    rm -rf build
    mkdir build
    pushd build
    if [ "x" = "x${TRAVIS_TAG}" ] ;  then
        cmake .. -DRASPBIAN_TOOLCHAIN_DIR=${WILTON_RPI_TOOLCHAIN} -DSTATICLIB_TOOLCHAIN=linux_armhf_gcc -DWILTON_BUILD_FLAVOUR=raspbian_stretch
    else
        cmake .. -DRASPBIAN_TOOLCHAIN_DIR=${WILTON_RPI_TOOLCHAIN} -DSTATICLIB_TOOLCHAIN=linux_armhf_gcc -DWILTON_BUILD_FLAVOUR=raspbian_stretch -DWILTON_RELEASE=${TRAVIS_TAG}
    fi
    make -j 2
    make dist_debug > dist_debug.log
    make dist_unversioned > dist_unversioned.log
    if [ "x" != "x${TRAVIS_TAG}" ] ;  then
        mv wilton_${TRAVIS_TAG} wilton_${TRAVIS_TAG}_rpi
        zip -qr9 wilton_${TRAVIS_TAG}_rpi.zip wilton_${TRAVIS_TAG}_rpi
    fi

    # raspberry test runs
    export LD_LIBRARY_PATH=${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/usr/lib/arm-linux-gnueabihf/
    qemu-arm-static -L ${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/ ./wilton_dist/bin/wilton ../js/wilton/test/LoggerTest.js -m ../js -j duktape -l
    qemu-arm-static -L ${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/ ./wilton_dist/bin/wilton ../js/wilton/test/fsTest.js -m ../js -j duktape -l
    qemu-arm-static -L ${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/ ./wilton_dist/bin/wilton ../js/wilton/test/gitTest.js -m ../js -j duktape -l
    qemu-arm-static -L ${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/ ./wilton_dist/bin/wilton ../js/wilton/test/threadTest.js -m ../js -j duktape -l
    qemu-arm-static -L ${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/ ./wilton_dist/bin/wilton ../js/wilton/test/zipTest.js -m ../js -j duktape -l
    qemu-arm-static -L ${WILTON_RPI_TOOLCHAIN}/arm-linux-gnueabihf/sysroot/ ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j duktape
fi

if [ "xosx" = "x${TRAVIS_OS_NAME}"  ] ; then
    set +e
    mkdir build
    pushd build
    set -e
    if [ "x" = "x${TRAVIS_TAG}" ] ;  then
        cmake ..
    else
        cmake .. -DWILTON_RELEASE=${TRAVIS_TAG}
    fi
    make -j 2
    make dist_debug > dist_debug.log

    # test
    make dist_unversioned > dist_unversioned.log

    echo jsc
    ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j jsc
    # hangs on CI
    #./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j jsc > stdlib.log
    ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j jsc

    echo duktape
    ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j duktape
    ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j duktape
    if [ "x" != "x${TRAVIS_TAG}" ] ;  then
        mv wilton_${TRAVIS_TAG} wilton_${TRAVIS_TAG}_macos
        zip -qr9 wilton_${TRAVIS_TAG}_macos.zip wilton_${TRAVIS_TAG}_macos
    fi
fi

echo WILTON_FINISH_SUCCESS

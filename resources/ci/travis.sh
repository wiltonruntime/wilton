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
    git clone --quiet --recursive https://github.com/wiltonruntime/android-tools-ci-repo.git ../android-tools

    # env
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    export M2_HOME=`pwd`/tools/maven
    export WILTON_ANDROID_TOOLS=`pwd`/../android-tools

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

fi

if [ "xosx" = "x${TRAVIS_OS_NAME}"  ] ; then
 
    # env
    export JAVA_HOME=$(/usr/libexec/java_home)

    # build
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

    # drop original bin dir to make sure deps from dist are used
    rm -rf ./bin

    echo quickjs
    ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js
    ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js
    ./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js > quickjs_stdlib.log

    echo jsc
    ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j jsc
    # hangs on CI
    #./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j jsc > jsc_stdlib.log
    ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j jsc

    echo duktape
    ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j duktape
    ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j duktape

    if [ "x" != "x${TRAVIS_TAG}" ] ;  then
        mv wilton_${TRAVIS_TAG} wilton_${TRAVIS_TAG}_macos
        zip -qr9 wilton_${TRAVIS_TAG}_macos.zip wilton_${TRAVIS_TAG}_macos
    fi
fi

echo WILTON_FINISH_SUCCESS

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

# detect container
export VERSION_XENIAL=`cat /etc/os-release | grep xenial | wc -l`
export VERSION_STRETCH=`cat /etc/os-release | grep stretch | wc -l`
export VERSION_BIONIC=`cat /etc/os-release | grep bionic | wc -l`

if [ "x2" = "x${VERSION_XENIAL}" ] ; then
    # there are no separate flavour for xenial
    export WILTON_BUILD_FLAVOUR=stretch
    export WILTON_ARCH=armhf
    export WILTON_QEMU_ARCH=arm
    export WILTON_IMAGE_POSTFIX=xenial
    export LANG=C
fi
if [ "x3" = "x${VERSION_STRETCH}" ] ; then
    export WILTON_BUILD_FLAVOUR=stretch
    export WILTON_ARCH=aarch64
    export WILTON_QEMU_ARCH=aarch64
    export WILTON_IMAGE_POSTFIX=stretch
fi
if [ "x2" = "x${VERSION_BIONIC}" ] ; then
    export WILTON_BUILD_FLAVOUR=bionic
    export WILTON_ARCH=amd64
    export WILTON_IMAGE_POSTFIX=bionic
    # additional engines
    git submodule update --quiet --init deps/external_chakracore
    git submodule update --quiet --init deps/external_icu
    git submodule update --quiet --init deps/external_mozjs
    git submodule update --quiet --init deps/external_v8
    git submodule update --quiet --init engines/wilton_chakracore
    git submodule update --quiet --init engines/wilton_mozjs
    git submodule update --quiet --init engines/wilton_v8
fi

export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")

# build
mkdir build
pushd build
if [ "x" = "x${CIRRUS_TAG}" ] ;  then
    cmake .. -DSTATICLIB_TOOLCHAIN=linux_${WILTON_ARCH}_gcc -DWILTON_BUILD_FLAVOUR=${WILTON_BUILD_FLAVOUR}
else
    cmake .. -DSTATICLIB_TOOLCHAIN=linux_${WILTON_ARCH}_gcc -DWILTON_BUILD_FLAVOUR=${WILTON_BUILD_FLAVOUR} -DWILTON_RELEASE=${CIRRUS_TAG}
fi
make #-j 2
make dist_debug > dist_debug.log

# test
make dist_unversioned > dist_unversioned.log

if [ "xbionic" = "x${WILTON_BUILD_FLAVOUR}" ] ; then

echo jsc
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j jsc
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j jsc
./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j jsc > jsc_stdlib.log

echo duktape
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j duktape
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j duktape

echo quickjs
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j quickjs
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j quickjs

echo chakracore
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j chakracore
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j chakracore
./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j chakracore > chakracore_stdlib.log

echo mozjs
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j mozjs
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j mozjs
# intermittent out of memory
./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j mozjs > mozjs_stdlib.log || true

echo v8
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j v8
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j v8
./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j v8 > v8_stdlib.log

echo jvm
pushd ../jni
../tools/maven/bin/mvn --batch-mode clean test
popd

export JAVA_TOOL_OPTIONS="-XX:MaxRAM=512M -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

echo rhino
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j rhino
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j rhino

echo nashorn
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j nashorn
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j nashorn

else # QEMU

    echo duktape
    qemu-${WILTON_QEMU_ARCH}-static ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j duktape
    qemu-${WILTON_QEMU_ARCH}-static ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j duktape

    echo quickjs
    qemu-${WILTON_QEMU_ARCH}-static ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j quickjs
    qemu-${WILTON_QEMU_ARCH}-static ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -m ./wilton_dist/std.min.wlib -j quickjs

fi

if [ "x" != "x${CIRRUS_TAG}" ] ;  then
    export IMAGE=wilton_${CIRRUS_TAG}_${WILTON_ARCH}_${WILTON_IMAGE_POSTFIX}
    mv ./wilton_${CIRRUS_TAG} ${IMAGE}
    zip -qyr9 ${IMAGE}.zip ${IMAGE}
    ../../ghr/ghr -t ${GITHUB_TOKEN} -u wilton-iot -r wilton -c ${CIRRUS_CHANGE_IN_REPO} ${CIRRUS_TAG} ${IMAGE}.zip
fi

echo WILTON_FINISH_SUCCESS

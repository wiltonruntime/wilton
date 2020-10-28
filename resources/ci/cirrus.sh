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

export JAVA_HOME=/opt/jdk8

# build
mkdir build
pushd build
if [ "x" = "x${CIRRUS_TAG}" ] ;  then
    cmake .. -DSTATICLIB_TOOLCHAIN=linux_armhf_gcc -DWILTON_BUILD_FLAVOUR=crosspi
else
    cmake .. -DSTATICLIB_TOOLCHAIN=linux_armhf_gcc -DWILTON_BUILD_FLAVOUR=crosspi -DWILTON_RELEASE=${CIRRUS_TAG}
fi
make #-j 2
make dist > dist.log

# test
# broken on ext4, see: https://sourceware.org/bugzilla/show_bug.cgi?id=23960
# works locally on fedora+podman
#
#make dist_unversioned > dist_unversioned.log
#export LD_LIBRARY_PATH=/opt/cross-pi-gcc-sysroot/usr/lib/arm-linux-gnueabihf/
#export QEMU_LD_PREFIX=/opt/cross-pi-gcc/arm-linux-gnueabihf/
#
#echo quickjs
#/opt/cross-pi-gcc-sysroot/usr/bin/qemu-arm-static ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js
#/opt/cross-pi-gcc-sysroot/usr/bin/qemu-arm-static ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js
#
#echo jsc
#/opt/cross-pi-gcc-sysroot/usr/bin/qemu-arm-static ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j jsc
#/opt/cross-pi-gcc-sysroot/usr/bin/qemu-arm-static ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j jsc
#
#echo duktape
#/opt/cross-pi-gcc-sysroot/usr/bin/qemu-arm-static ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j duktape
#/opt/cross-pi-gcc-sysroot/usr/bin/qemu-arm-static ./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j duktape

if [ "x" != "x${CIRRUS_TAG}" ] ;  then
    export IMAGE=wilton_${CIRRUS_TAG}_rpi
    mv ./wilton_${CIRRUS_TAG} ${IMAGE}
    zip -qyr9 ${IMAGE}.zip ${IMAGE}
    ../../ghr/ghr -t ${GITHUB_TOKEN} -u wiltonruntime -r wilton -c ${CIRRUS_CHANGE_IN_REPO} ${CIRRUS_TAG} ${IMAGE}.zip
fi

echo WILTON_FINISH_SUCCESS

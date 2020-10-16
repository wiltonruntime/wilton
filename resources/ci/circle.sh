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

if [ "xwheezy" = "x${WILTON_BUILD_FLAVOUR}" ] ; then
    export JAVA_HOME=/opt/jdk8
    git clone --quiet https://github.com/wiltonruntime/tools_linux_cmake.git ../cmake
    export PATH=`pwd`/../cmake/bin:${PATH}
fi

if [ "xel7" = "x${WILTON_BUILD_FLAVOUR}" ] || [ "xel8" = "x${WILTON_BUILD_FLAVOUR}" ] ; then
    export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
fi

# build
mkdir build
pushd build
if [ "x" = "x${CIRCLE_TAG}" ] ;  then
    cmake .. -DWILTON_BUILD_FLAVOUR=${WILTON_BUILD_FLAVOUR}
else
    cmake .. -DWILTON_BUILD_FLAVOUR=${WILTON_BUILD_FLAVOUR} -DWILTON_RELEASE=${CIRCLE_TAG}
fi
make -j 2
make dist_debug > dist_debug.log

# test
make dist_unversioned > dist_unversioned.log

echo quickjs
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js
./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js > quickjs_stdlib.log

echo jsc
if [ "xel7" = "x${WILTON_BUILD_FLAVOUR}" ] || [ "xel8" = "x${WILTON_BUILD_FLAVOUR}" ] ; then
    ./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j jsc
    ./wilton_dist/bin/wilton ../js/test-runners/runStdLibTests.js -m ../js -j jsc > jsc_stdlib.log
fi
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j jsc

echo duktape
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j duktape
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j duktape

echo jvm
pushd ../jni
../tools/maven/bin/mvn --batch-mode clean test
popd

export JAVA_TOOL_OPTIONS="-XX:MaxRAM=512M -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1"

echo rhino
./wilton_dist/bin/wilton ../js/wilton/test/index.js -m ../js -j rhino
./wilton_dist/bin/wilton ../js/test-runners/runSanityTests.js -j rhino

echo valgrind
make valgrind

echo WILTON_FINISH_SUCCESS

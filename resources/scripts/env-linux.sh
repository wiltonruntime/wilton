#!/bin/bash

# Copyright 2017, alex at staticlibs.net
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

WILTON_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../../

export PATH=$PATH:"$WILTON_DIR"/tools/linux/cmake/bin
export PATH=$PATH:"$WILTON_DIR"/tools/linux/jdk8/bin
export PATH=$PATH:"$WILTON_DIR"/deps/cmake/resources/creset

export JAVA_HOME="$WILTON_DIR"/tools/linux/jdk8
export M2_HOME="$WILTON_DIR"/tools/maven

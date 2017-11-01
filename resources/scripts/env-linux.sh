#!/bin/bash

WILTON_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../../

export PATH=$PATH:"$WILTON_DIR"/tools/linux/cmake/bin
export PATH=$PATH:"$WILTON_DIR"/tools/linux/jdk8/bin
export PATH=$PATH:"$WILTON_DIR"/deps/cmake/resources/creset

export JAVA_HOME="$WILTON_DIR"/tools/linux/jdk8
export M2_HOME="$WILTON_DIR"/tools/maven

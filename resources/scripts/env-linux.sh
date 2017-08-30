#!/bin/bash

WILTON_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../../

PATH=$PATH:"$WILTON_DIR"/tools/linux/cmake/bin
PATH=$PATH:"$WILTON_DIR"/tools/linux/jdk8/bin
PATH=$PATH:"$WILTON_DIR"/deps/cmake/resources/creset

JAVA_HOME="$WILTON_DIR"/tools/linux/jdk8
M2_HOME="$WILTON_DIR"/tools/maven

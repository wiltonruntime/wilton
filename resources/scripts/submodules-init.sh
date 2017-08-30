#!/bin/bash

set -e
set -x

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat "$SCRIPT_DIR"/submodules-linux.txt | while read mod ; do git submodule update --init --recursive $mod ; done

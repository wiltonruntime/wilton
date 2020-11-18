#!/bin/bash 
#
# Copyright 2019, alex at staticlibs.net
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

if [ -z "$1" ] ; then
    echo "Version number not specified"
    exit 1
fi

VERSION=$1

git clone --branch v$VERSION https://github.com/wiltonruntime/wilton.git wilton-$VERSION
cd wilton-$VERSION

# core
git submodule update --quiet --init core
# deps
git submodule update --quiet --init deps/cmake
git submodule update --quiet --init deps/external_duktape
git submodule update --quiet --init deps/external_quickjs
git submodule update --quiet --init deps/external_utf8cpp
git submodule update --quiet --init deps/lookaside_utf8cpp
git submodule update --quiet --init deps/staticlib_compress
git submodule update --quiet --init deps/staticlib_concurrent
git submodule update --quiet --init deps/staticlib_config
git submodule update --quiet --init deps/staticlib_cron
git submodule update --quiet --init deps/ccronexpr
git submodule update --quiet --init deps/staticlib_crypto
git submodule update --quiet --init deps/staticlib_endian
git submodule update --quiet --init deps/staticlib_http
git submodule update --quiet --init deps/staticlib_io
git submodule update --quiet --init deps/staticlib_jni
git submodule update --quiet --init deps/staticlib_json
git submodule update --quiet --init deps/staticlib_mustache
git submodule update --quiet --init deps/mstch_cpp11
git submodule update --quiet --init deps/staticlib_orm
git submodule update --quiet --init deps/staticlib_pimpl
git submodule update --quiet --init deps/staticlib_pion
git submodule update --quiet --init deps/staticlib_ranges
git submodule update --quiet --init deps/staticlib_support
git submodule update --quiet --init deps/staticlib_tinydir
git submodule update --quiet --init deps/tinydir
git submodule update --quiet --init deps/staticlib_unzip
git submodule update --quiet --init deps/staticlib_utils
git submodule update --quiet --init deps/staticlib_websocket
# jni
git submodule update --quiet --init jni
# engines
git submodule update --quiet --init engines/wilton_duktape
git submodule update --quiet --init engines/wilton_jsc
git submodule update --quiet --init engines/wilton_quickjs
git submodule update --quiet --init engines/wilton_rhino
# modules
git submodule update --quiet --init modules/wilton_channel
git submodule update --quiet --init modules/wilton_cli
git submodule update --quiet --init modules/wilton_cron
git submodule update --quiet --init modules/wilton_crypto
git submodule update --quiet --init modules/wilton_db
git submodule update --quiet --init modules/wilton_fs
git submodule update --quiet --init modules/wilton_ghc
git submodule update --quiet --init modules/wilton_git
git submodule update --quiet --init modules/wilton_http
git submodule update --quiet --init modules/wilton_kiosk
git submodule update --quiet --init modules/wilton_kvstore
git submodule update --quiet --init modules/wilton_loader
git submodule update --quiet --init modules/wilton_logging
git submodule update --quiet --init modules/wilton_mustache
git submodule update --quiet --init modules/wilton_net
git submodule update --quiet --init modules/wilton_pdf
git submodule update --quiet --init modules/wilton_process
git submodule update --quiet --init modules/wilton_serial
git submodule update --quiet --init modules/wilton_server
git submodule update --quiet --init modules/wilton_service
git submodule update --quiet --init modules/wilton_signal
git submodule update --quiet --init modules/wilton_systemd
git submodule update --quiet --init modules/wilton_thread
git submodule update --quiet --init modules/wilton_zip
# tools
git submodule update --quiet --init tools/maven
git submodule update --quiet --init tools/mvnrepo

# js
git submodule update --quiet --init js/wilton-requirejs
git clone --quiet --branch v$VERSION https://github.com/wiltonruntime/js-libs-ci-monorepo.git js_mono
./resources/builder/builder bundle-stdlib-modules js_mono js_filter
cp -a js_mono/examples js_filter/
rm -rf js_mono
rm -rf js
mv js_filter js

# cleanup
rm -rf .git

# orig tarball
cd ..
tar cJf wilton_$VERSION.orig.tar.xz wilton-$VERSION

# deb scripts
cd wilton-$VERSION
cp -a ./resources/packages/debian .

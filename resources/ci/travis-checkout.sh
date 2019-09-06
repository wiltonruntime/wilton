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

#android
git submodule update --quiet --init android
# core
git submodule update --quiet --init core
# deps
git submodule update --quiet --init deps/cmake
git submodule update --quiet --init deps/external_asio
git submodule update --quiet --init deps/lookaside_asio
git submodule update --quiet --init deps/external_chakracore
git submodule update --quiet --init deps/external_curl
git submodule update --quiet --init deps/lookaside_curl
git submodule update --quiet --init deps/external_duktape
git submodule update --quiet --init deps/external_hpdf
git submodule update --quiet --init deps/lookaside_libharu
git submodule update --quiet --init deps/external_icu
git submodule update --quiet --init deps/external_jansson
git submodule update --quiet --init deps/lookaside_jansson
git submodule update --quiet --init deps/external_libgit2
git submodule update --quiet --init deps/lookaside_libgit2
git submodule update --quiet --init deps/external_libpng
git submodule update --quiet --init deps/lookaside_libpng
git submodule update --quiet --init deps/external_libpq
git submodule update --quiet --init deps/lookaside_postgresql
git submodule update --quiet --init deps/external_libssh2
git submodule update --quiet --init deps/lookaside_libssh2
git submodule update --quiet --init deps/external_log4cplus
git submodule update --quiet --init deps/lookaside_log4cplus
git submodule update --quiet --init deps/external_mozjs
git submodule update --quiet --init deps/external_openssl
git submodule update --quiet --init deps/lookaside_openssl
git submodule update --quiet --init deps/external_popt
git submodule update --quiet --init deps/lookaside_popt
git submodule update --quiet --init deps/external_soci
git submodule update --quiet --init deps/lookaside_soci
git submodule update --quiet --init deps/external_sqlite
git submodule update --quiet --init deps/external_v8
git submodule update --quiet --init deps/external_utf8cpp
git submodule update --quiet --init deps/lookaside_utf8cpp
git submodule update --quiet --init deps/external_zlib
git submodule update --quiet --init deps/lookaside_zlib
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
# js
rm -rf js
git clone --quiet https://github.com/wilton-iot/js-libs-ci-monorepo.git js
if [ "x" != "x${TRAVIS_TAG}" ] ;  then
    pushd js
    git checkout ${TRAVIS_TAG}
    popd
fi
# engines
git submodule update --quiet --init engines/wilton_duktape
git submodule update --quiet --init engines/wilton_jsc
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
git submodule update --quiet --init modules/wilton_usb
git submodule update --quiet --init modules/wilton_zip
# tools
git submodule update --quiet --init tools/closure-compiler
git submodule update --quiet --init tools/convertion-scripts
git submodule update --quiet --init tools/maven
git submodule update --quiet --init tools/mvnrepo

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
git submodule update --init android
# core
git submodule update --init core
# deps
git submodule update --init deps/cmake
git submodule update --init deps/external_asio
git submodule update --init deps/lookaside_asio
git submodule update --init deps/external_curl
git submodule update --init deps/lookaside_curl
git submodule update --init deps/external_duktape
git submodule update --init deps/external_hpdf
git submodule update --init deps/lookaside_libharu
git submodule update --init deps/external_jansson
git submodule update --init deps/lookaside_jansson
git submodule update --init deps/external_libpng
git submodule update --init deps/lookaside_libpng
git submodule update --init deps/external_libpq
git submodule update --init deps/lookaside_postgresql
git submodule update --init deps/external_log4cplus
git submodule update --init deps/lookaside_log4cplus
git submodule update --init deps/external_openssl
git submodule update --init deps/lookaside_openssl
git submodule update --init deps/external_popt
git submodule update --init deps/lookaside_popt
git submodule update --init deps/external_soci
git submodule update --init deps/lookaside_soci
git submodule update --init deps/external_sqlite
git submodule update --init deps/external_zlib
git submodule update --init deps/lookaside_zlib
git submodule update --init deps/staticlib_compress
git submodule update --init deps/staticlib_concurrent
git submodule update --init deps/staticlib_config
git submodule update --init deps/staticlib_cron
git submodule update --init deps/ccronexpr
git submodule update --init deps/staticlib_crypto
git submodule update --init deps/staticlib_endian
git submodule update --init deps/staticlib_http
git submodule update --init deps/staticlib_io
git submodule update --init deps/staticlib_jni
git submodule update --init deps/staticlib_json
git submodule update --init deps/staticlib_mustache
git submodule update --init deps/mstch_cpp11
git submodule update --init deps/staticlib_orm
git submodule update --init deps/staticlib_pimpl
git submodule update --init deps/staticlib_pion
git submodule update --init deps/staticlib_ranges
git submodule update --init deps/staticlib_support
git submodule update --init deps/staticlib_tinydir
git submodule update --init deps/tinydir
git submodule update --init deps/staticlib_unzip
git submodule update --init deps/staticlib_utils
# jni
git submodule update --init jni
# js
rm -rf js
git clone https://github.com/wilton-iot/js-libs-ci-monorepo.git js
# modules
git submodule update --init modules/wilton_channel
git submodule update --init modules/wilton_cli
git submodule update --init modules/wilton_cron
git submodule update --init modules/wilton_crypto
git submodule update --init modules/wilton_db
git submodule update --init modules/wilton_duktape
git submodule update --init modules/wilton_fs
git submodule update --init modules/wilton_ghc
git submodule update --init modules/wilton_http
git submodule update --init modules/wilton_jsc
git submodule update --init modules/wilton_kiosk
git submodule update --init modules/wilton_loader
git submodule update --init modules/wilton_logging
git submodule update --init modules/wilton_mustache
git submodule update --init modules/wilton_net
git submodule update --init modules/wilton_pdf
git submodule update --init modules/wilton_process
git submodule update --init modules/wilton_rhino
git submodule update --init modules/wilton_serial
git submodule update --init modules/wilton_server
git submodule update --init modules/wilton_signal
git submodule update --init modules/wilton_thread
git submodule update --init modules/wilton_usb
git submodule update --init modules/wilton_zip
# tools
git submodule update --init tools/closure-compiler
git submodule update --init tools/convertion-scripts
git submodule update --init tools/maven
git submodule update --init tools/mvnrepo

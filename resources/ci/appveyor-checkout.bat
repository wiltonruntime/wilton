@echo off
rem Copyright 2018, alex at staticlibs.net
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

@echo on

rem core
git submodule update --init core || exit /b 1
rem deps
git submodule update --init deps/cmake || exit /b 1
git submodule update --init --recursive deps/external_asio || exit /b 1
git submodule update --init --recursive deps/external_curl || exit /b 1
git submodule update --init deps/external_duktape || exit /b 1
git submodule update --init --recursive deps/external_hpdf || exit /b 1
git submodule update --init --recursive deps/external_jansson || exit /b 1
git submodule update --init --recursive deps/external_libpng || exit /b 1
git submodule update --init --recursive deps/external_libpq || exit /b 1
git submodule update --init --recursive deps/external_log4cplus || exit /b 1
git submodule update --init --recursive deps/external_openssl || exit /b 1
git submodule update --init --recursive deps/external_popt || exit /b 1
git submodule update --init --recursive deps/external_soci || exit /b 1
git submodule update --init deps/external_sqlite || exit /b 1
git submodule update --init --recursive deps/external_zlib || exit /b 1
git submodule update --init deps/staticlib_compress || exit /b 1
git submodule update --init deps/staticlib_concurrent || exit /b 1
git submodule update --init deps/staticlib_config || exit /b 1
git submodule update --init --recursive deps/staticlib_cron || exit /b 1
git submodule update --init deps/staticlib_crypto || exit /b 1
git submodule update --init deps/staticlib_endian || exit /b 1
git submodule update --init deps/staticlib_http || exit /b 1
git submodule update --init deps/staticlib_io || exit /b 1
git submodule update --init deps/staticlib_jni || exit /b 1
git submodule update --init deps/staticlib_json || exit /b 1
git submodule update --init --recursive deps/staticlib_mustache || exit /b 1
git submodule update --init deps/staticlib_orm || exit /b 1
git submodule update --init deps/staticlib_pimpl || exit /b 1
git submodule update --init deps/staticlib_pion || exit /b 1
git submodule update --init deps/staticlib_ranges || exit /b 1
git submodule update --init deps/staticlib_support || exit /b 1
git submodule update --init --recursive deps/staticlib_tinydir || exit /b 1
git submodule update --init deps/staticlib_unzip || exit /b 1
git submodule update --init deps/staticlib_utils || exit /b 1
git submodule update --init deps/staticlib_winservice || exit /b 1
rem jni
git submodule update --init jni || exit /b 1
rem js
rd /s /q js
git clone https://github.com/wilton-iot/js-libs-ci-monorepo.git js || exit /b 1
git submodule update --init modules/wilton_chakra || exit /b 1
git submodule update --init modules/wilton_channel || exit /b 1
git submodule update --init modules/wilton_cli || exit /b 1
git submodule update --init modules/wilton_cron || exit /b 1
git submodule update --init modules/wilton_crypto || exit /b 1
git submodule update --init modules/wilton_db || exit /b 1
git submodule update --init modules/wilton_duktape || exit /b 1
git submodule update --init modules/wilton_fs || exit /b 1
git submodule update --init modules/wilton_http || exit /b 1
git submodule update --init modules/wilton_jsc || exit /b 1
git submodule update --init modules/wilton_loader || exit /b 1
git submodule update --init modules/wilton_logging || exit /b 1
git submodule update --init modules/wilton_net || exit /b 1
git submodule update --init modules/wilton_pdf || exit /b 1
git submodule update --init modules/wilton_process || exit /b 1
git submodule update --init modules/wilton_rhino || exit /b 1
git submodule update --init modules/wilton_serial || exit /b 1
git submodule update --init modules/wilton_server || exit /b 1
git submodule update --init modules/wilton_signal || exit /b 1
git submodule update --init modules/wilton_thread || exit /b 1
git submodule update --init modules/wilton_usb || exit /b 1
git submodule update --init modules/wilton_winservice || exit /b 1
git submodule update --init modules/wilton_zip || exit /b 1
rem tools
rem git submodule update --init tools/closure-compiler || exit /b 1
git submodule update --init tools/convertion-scripts || exit /b 1
git submodule update --init tools/maven || exit /b 1
git submodule update --init tools/windows/nasm || exit /b 1
git submodule update --init tools/windows/perl520 || exit /b 1
git submodule update --init tools/windows/pkgconfig || exit /b 1
git submodule update --init tools/windows/wix || exit /b 1
git submodule update --init tools/windows/wixgen || exit /b 1
git submodule update --init tools/windows/zip || exit /b 1
rem additional tools
rem git clone https://github.com/wilton-iot/tools_windows_jdk8.git tools/windows/jdk8
git clone https://github.com/wilton-iot/tools_windows_jdk8_64.git tools/windows/jdk8_64

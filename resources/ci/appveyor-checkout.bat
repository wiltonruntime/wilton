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
git submodule update --quiet --init core || exit /b 1
rem deps
git submodule update --quiet --init deps/cmake || exit /b 1
git submodule update --quiet --init deps/external_asio || exit /b 1
git submodule update --quiet --init deps/lookaside_asio || exit /b 1
git submodule update --quiet --init deps/external_curl || exit /b 1
git submodule update --quiet --init deps/lookaside_curl || exit /b 1
git submodule update --quiet --init deps/external_duktape || exit /b 1
git submodule update --quiet --init deps/external_hpdf || exit /b 1
git submodule update --quiet --init deps/lookaside_libharu || exit /b 1
git submodule update --quiet --init deps/external_jansson || exit /b 1
git submodule update --quiet --init deps/lookaside_jansson || exit /b 1
git submodule update --quiet --init deps/external_libgit2 || exit /b 1
git submodule update --quiet --init deps/lookaside_libgit2 || exit /b 1
git submodule update --quiet --init deps/external_libjpeg-turbo || exit /b 1
git submodule update --quiet --init deps/lookaside_libjpeg-turbo || exit /b 1
git submodule update --quiet --init deps/external_libpng || exit /b 1
git submodule update --quiet --init deps/lookaside_libpng || exit /b 1
git submodule update --quiet --init deps/external_libpq || exit /b 1
git submodule update --quiet --init deps/lookaside_postgresql || exit /b 1
git submodule update --quiet --init deps/external_libssh2 || exit /b 1
git submodule update --quiet --init deps/lookaside_libssh2 || exit /b 1
git submodule update --quiet --init deps/external_log4cplus || exit /b 1
git submodule update --quiet --init deps/lookaside_log4cplus || exit /b 1
git submodule update --quiet --init deps/external_quickjs || exit /b 1
git submodule update --quiet --init deps/external_openssl || exit /b 1
git submodule update --quiet --init deps/lookaside_openssl || exit /b 1
git submodule update --quiet --init deps/external_popt || exit /b 1
git submodule update --quiet --init deps/lookaside_popt || exit /b 1
git submodule update --quiet --init deps/external_soci || exit /b 1
git submodule update --quiet --init deps/lookaside_soci || exit /b 1
git submodule update --quiet --init deps/external_sqlite || exit /b 1
git submodule update --quiet --init deps/external_utf8cpp || exit /b 1
git submodule update --quiet --init deps/lookaside_utf8cpp || exit /b 1
git submodule update --quiet --init deps/external_zlib || exit /b 1
git submodule update --quiet --init deps/lookaside_zlib || exit /b 1
git submodule update --quiet --init deps/staticlib_compress || exit /b 1
git submodule update --quiet --init deps/staticlib_concurrent || exit /b 1
git submodule update --quiet --init deps/staticlib_config || exit /b 1
git submodule update --quiet --init deps/staticlib_cron || exit /b 1
git submodule update --quiet --init deps/ccronexpr || exit /b 1
git submodule update --quiet --init deps/staticlib_crypto || exit /b 1
git submodule update --quiet --init deps/staticlib_endian || exit /b 1
git submodule update --quiet --init deps/staticlib_http || exit /b 1
git submodule update --quiet --init deps/staticlib_io || exit /b 1
git submodule update --quiet --init deps/staticlib_jni || exit /b 1
git submodule update --quiet --init deps/staticlib_json || exit /b 1
git submodule update --quiet --init deps/staticlib_mustache || exit /b 1
git submodule update --quiet --init deps/mstch_cpp11 || exit /b 1
git submodule update --quiet --init deps/staticlib_orm || exit /b 1
git submodule update --quiet --init deps/staticlib_pimpl || exit /b 1
git submodule update --quiet --init deps/staticlib_pion || exit /b 1
git submodule update --quiet --init deps/staticlib_ranges || exit /b 1
git submodule update --quiet --init deps/staticlib_support || exit /b 1
git submodule update --quiet --init deps/staticlib_tinydir || exit /b 1
git submodule update --quiet --init deps/tinydir || exit /b 1
git submodule update --quiet --init deps/staticlib_unzip || exit /b 1
git submodule update --quiet --init deps/staticlib_utils || exit /b 1
git submodule update --quiet --init deps/staticlib_websocket || exit /b 1
rem jni
git submodule update --quiet --init jni || exit /b 1
rem js
rd /s /q js
git clone --quiet https://github.com/wilton-iot/js-libs-ci-monorepo.git js || exit /b 1
if "x" NEQ "x%APPVEYOR_REPO_TAG_NAME%" (
    pushd js || exit /b 1
    git checkout %APPVEYOR_REPO_TAG_NAME% || exit /b 1
    popd || exit /b 1
)
rem engines
git submodule update --quiet --init engines/wilton_chakra || exit /b 1
git submodule update --quiet --init engines/wilton_duktape || exit /b 1
git submodule update --quiet --init engines/wilton_quickjs || exit /b 1
git submodule update --quiet --init engines/wilton_rhino || exit /b 1
rem modules
git submodule update --quiet --init modules/wilton_channel || exit /b 1
git submodule update --quiet --init modules/wilton_cli || exit /b 1
git submodule update --quiet --init modules/wilton_cron || exit /b 1
git submodule update --quiet --init modules/wilton_crypto || exit /b 1
git submodule update --quiet --init modules/wilton_db || exit /b 1
git submodule update --quiet --init modules/wilton_fs || exit /b 1
git submodule update --quiet --init modules/wilton_ghc || exit /b 1
git submodule update --quiet --init modules/wilton_git || exit /b 1
git submodule update --quiet --init modules/wilton_http || exit /b 1
git submodule update --quiet --init modules/wilton_kvstore || exit /b 1
git submodule update --quiet --init modules/wilton_loader || exit /b 1
git submodule update --quiet --init modules/wilton_logging || exit /b 1
git submodule update --quiet --init modules/wilton_mustache || exit /b 1
git submodule update --quiet --init modules/wilton_net || exit /b 1
git submodule update --quiet --init modules/wilton_pdf || exit /b 1
git submodule update --quiet --init modules/wilton_process || exit /b 1
git submodule update --quiet --init modules/wilton_serial || exit /b 1
git submodule update --quiet --init modules/wilton_server || exit /b 1
git submodule update --quiet --init modules/wilton_service || exit /b 1
git submodule update --quiet --init modules/wilton_signal || exit /b 1
git submodule update --quiet --init modules/wilton_thread || exit /b 1
git submodule update --quiet --init modules/wilton_usb || exit /b 1
git submodule update --quiet --init modules/wilton_winscm || exit /b 1
git submodule update --quiet --init modules/wilton_zip || exit /b 1
rem tools
git submodule update --quiet --init tools/maven || exit /b 1
git submodule update --quiet --init tools/mvnrepo || exit /b 1
git clone --quiet --recursive https://github.com/wilton-iot/windows_build_tools.git ../tools

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
pushd core && git checkout master && git pull --quiet && popd || exit /b 1
rem jni
pushd jni && git checkout master && git pull --quiet && popd || exit /b 1
rem engines
pushd "engines/wilton_chakra" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "engines/wilton_duktape" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "engines/wilton_quickjs" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "engines/wilton_rhino" && git checkout master && git pull --quiet && popd || exit /b 1
rem modules
pushd "modules/wilton_channel" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_cli" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_cron" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_crypto" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_db" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_fs" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_ghc" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_git" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_http" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_kvstore" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_loader" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_logging" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_mustache" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_net" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_pdf" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_process" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_serial" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_server" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_service" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_signal" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_thread" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_winscm" && git checkout master && git pull --quiet && popd || exit /b 1
pushd "modules/wilton_zip" && git checkout master && git pull --quiet && popd || exit /b 1
pushd jni && git checkout master && git pull --quiet && popd || exit /b 1

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

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set WILTON_DIR=%SCRIPT_DIR%/../..

rem set path
set PATH=%PATH%;%WILTON_DIR%/tools/windows/nasm
set PATH=%PATH%;%WILTON_DIR%/tools/windows/pkgconfig/bin
set PATH=%PATH%;%WILTON_DIR%/tools/windows/perl520/perl/bin
set PATH=%PATH%;%WILTON_DIR%/tools/windows/zip
set PATH=%PATH%;%WILTON_DIR%/deps/cmake/resources/creset

rem set vars for maven
set M2_HOME=%WILTON_DIR%/tools/maven

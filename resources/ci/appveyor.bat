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

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set WILTON_DIR=%SCRIPT_DIR%../..

rem env
call resources\scripts\windows-tools.bat
set PATH=%WILTON_DIR%/tools/windows/jdk8/bin;%PATH%

rem build
mkdir build || exit /b 1
cd build || exit /b 1
cmake .. -G "Visual Studio 12 2013" -T v120_xp || exit /b 1
cmake --build . --config Release --target installer || exit /b 1
cmake --build . --config Release --target test_duktape > test_duktape.log || exit /b 1
cmake --build . --config Release --target test_jvm > test_jvm.log || exit /b 1

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

rem env
call resources\scripts\set-compile-env-vs12-sdk71a-x86.bat

rem build
mkdir build || exit /b 1
cd build || exit /b 1
cmake .. -G "NMake Makefiles" || exit /b 1
nmake installer || exit /b 1
nmake test_duktape > test_duktape.log || exit /b 1
nmake test_jvm > test_jvm.log || exit /b 1

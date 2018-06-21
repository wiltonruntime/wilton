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

rem build x86_64
set PATH=%WILTON_DIR%/tools/windows/jdk8_64/bin;%PATH%
mkdir build || exit /b 1
pushd build || exit /b 1
cmake .. -G "Visual Studio 12 2013 Win64" || exit /b 1
cmake --build . --config Release --target installer
if errorlevel 1 (
    echo error, target: installer
    exit /b 1
)

echo test_js
rem for some reason chakra segfaults when run from msbuild
rem cmake --build . --config Release --target test_js > test_js.log
cmake --build . --config Release --target dist_unversioned > dist_unversioned.log
wilton_dist\bin\wilton.exe -m ../js ../js/wilton/test/index.js
if errorlevel 1 (
    echo error, target: test_js_wilton
    exit /b 1
)
wilton_dist\bin\wilton.exe -m ../js ../js/test-runners/runNodeTests.js > test_js_wilton.log
if errorlevel 1 (
    echo error, target: test_js_node
    exit /b 1
)
wilton_dist\bin\wilton.exe -m wilton_dist/std.min.wlib ../js/test-runners/runSanityTests.js
if errorlevel 1 (
    echo error, target: test_js_sanity
    exit /b 1
)
echo test_duktape
cmake --build . --config Release --target test_duktape > test_duktape.log
if errorlevel 1 (
    echo error, target: test_duktape
    exit /b 1
)
echo test_jvm
cmake --build . --config Release --target test_jvm > test_jvm.log
if errorlevel 1 (
    echo error, target: test_jvm
    exit /b 1
)

echo dist_windows_jre
cmake --build . --config Release --target dist_windows_jre

echo test_rhino
cmake --build . --config Release --target test_rhino > test_rhino.log
if errorlevel 1 (
    echo error, target: test_rhino
    exit /b 1
)
echo test_nashorn
cmake --build . --config Release --target test_nashorn > test_nashorn.log
if errorlevel 1 (
    echo error, target: test_nashorn
    exit /b 1
)


rem cleanup
popd || exit /b 1
rem copy release
mkdir releases || exit /b 1
robocopy build releases wilton_%APPVEYOR_REPO_TAG_NAME%.msi /ndl /njh /njs /nc /ns /np || true
rd /s /q build

rem build x86 - WinXP
rem set PATH=%WILTON_DIR%/tools/windows/jdk8/bin;%PATH%
mkdir build || exit /b 1
pushd build || exit /b 1
cmake .. -G "Visual Studio 12 2013" -T v120_xp || exit /b 1
cmake --build . --config Release --target installer
if errorlevel 1 (
    echo msbuild error, target: installer
    exit /b 1
)

echo test_js
cmake --build . --config Release --target test_js > test_js.log
if errorlevel 1 (
    echo msbuild error, target: test_js
    exit /b 1
)

popd || exit /b 1
rem copy release
robocopy build releases wilton_%APPVEYOR_REPO_TAG_NAME%_x86.msi /ndl /njh /njs /nc /ns /np || true

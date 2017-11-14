@echo off

rem Copyright 2017, alex at staticlibs.net
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

rem tools dirs
set VS=%WILTON_DIR%/tools/windows/vs2013e
set WINSDK=%VS%/7.1A
set WINDDK=%WILTON_DIR%/tools/windows/ddk71

rem set compiler environment manually
set VCINSTALLDIR=%VS%\VC\
set VisualStudioVersion=12.0
set VS120COMNTOOLS=
set VSINSTALLDIR=%VS%
set WindowsSdkDir=%WINSDK%

set LIB=%WINSDK%/Lib;%VS%/VC/Lib;%WINDDK%/lib/wxp/i386
set LIBPATH=%VS%/VC/Lib
set INCLUDE=%WINSDK%/Include;%VS%/VC/INCLUDE;%WINDDK%/inc

rem set path
set PATH=%VS%/VC/Bin
set PATH=%PATH%;%WINSDK%/Bin;C:/WINDOWS/System32;C:/WINDOWS;C:/WINDOWS/System32/wbem
set PATH=%PATH%;%VS%/VC/redist/x86/Microsoft.VC120.CRT/msvcr120.dll
set PATH=%PATH%;%VS%/VC/redist/x86/Microsoft.VC120.CRT/msvcp120.dll
set PATH=%PATH%;%WILTON_DIR%/tools/windows/cmake/bin
set PATH=%PATH%;%WILTON_DIR%/tools/windows/jdk8/bin
set PATH=%PATH%;%WILTON_DIR%/tools/windows/nasm
set PATH=%PATH%;%WILTON_DIR%/tools/windows/pkgconfig/bin
set PATH=%PATH%;%WILTON_DIR%/tools/windows/perl/perl/bin
set PATH=%PATH%;%WILTON_DIR%/deps/cmake/resources/creset

rem set vars for maven
set JAVA_HOME=%WILTON_DIR%/tools/windows/jdk8
set M2_HOME=%WILTON_DIR%/tools/maven

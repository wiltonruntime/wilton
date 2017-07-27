@echo off
rem Copyright 2017 ...

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set WILTON_DIR=%SCRIPT_DIR%/../..

rem tools dirs
set VS=%WILTON_DIR%/tools/windows/vs2013e
set WINSDK=%VS%/7.1A

rem set compiler environment manually
set VCINSTALLDIR=%VS%\VC\
set VisualStudioVersion=12.0
set VS120COMNTOOLS=
set VSINSTALLDIR=%VS%
set WindowsSdkDir=%WINSDK%

set LIB=%WINSDK%/Lib;%VS%/VC/Lib
set LIBPATH=%VS%/VC/Lib
set INCLUDE=%WINSDK%/Include;%VS%/VC/INCLUDE

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
set PATH=%PATH%;%WILTON_DIR%/tools/windows/zip
set PATH=%PATH%;%WILTON_DIR%/deps/cmake/resources/creset


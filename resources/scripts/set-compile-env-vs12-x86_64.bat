@echo off
rem Copyright 2017 ...
@echo on

rem shortcuts from script directory
set BAD_SLASH_SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%BAD_SLASH_SCRIPT_DIR:\=/%
set WILTON_DIR=%SCRIPT_DIR%/../..

rem tools dirs
set VS=%WILTON_DIR%/tools/toolchain/vs2013e
set WINSDK=%VS%/8.1

rem set compiler environment manually
set VCINSTALLDIR=%VS%\VC\
set VisualStudioVersion=12.0
set VS120COMNTOOLS=
set VSINSTALLDIR=%VS%
set WindowsSdkDir=%WINSDK%

set LIB=%VS%/VC/Lib/amd64;%WINSDK%/Lib/x64
set LIBPATH=%VS%/VC/Lib/amd64
set INCLUDE=%VS%/VC/INCLUDE;

rem set path
set PATH=%VS%/VC/Bin/amd64;%VS%/VC/Bin
set PATH=%PATH%;%WINSDK%/Bin/x64;C:/WINDOWS/System32;C:/WINDOWS;C:/WINDOWS/System32/wbem
set PATH=%PATH%;%VS%/VC/redist/x64/Microsoft.VC120.CRT/msvcr120.dll
set PATH=%PATH%;%VS%/VC/redist/x64/Microsoft.VC120.CRT/msvcp120.dll
set PATH=%PATH%;%WILTON_DIR%/tools/cmake/bin
set PATH=%PATH%;%WILTON_DIR%/tools/pkgconfig/bin
set PATH=%PATH%;%WILTON_DIR%/resources/scripts

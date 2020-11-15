@echo off
rem Copyright 2020, alex at staticlibs.net
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

set BAD_SLASH_APP_DIR=%~dp0
set BUILDER_DIR=%BAD_SLASH_APP_DIR:\=/%
export WILTON_DIR=$BUILDER_DIR../../

if "x" == "x%JAVA_HOME%" (
    echo "'JAVA_HOME' environment variable must be defined"
    exit /b 1
)

if "x" == "x%1" (
    echo "USAGE: bin\builder <task> [args]"
    exit /b 1
)

"%JAVA_HOME%\bin\java" ^
        -XX:MaxRAM=256M ^
        -XX:+UseSerialGC ^
        -XX:+TieredCompilation ^
        -XX:TieredStopAtLevel=1 ^
        -cp "%WILTON_DIR%"tools/mvnrepo/org/mozilla/rhino/1.7.7.1/rhino-1.7.7.1.jar \
        org.mozilla.javascript.tools.shell.Main ^
        -O -1 ^
        "%BUILDER_DIR%"init/runTask.js ^
        "%*"


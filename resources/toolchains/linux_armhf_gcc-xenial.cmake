# Copyright 2017, alex at staticlibs.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required ( VERSION 2.8.12 )

set ( CMAKE_BUILD_TYPE "Release" CACHE STRING "Default build type" )

set ( CMAKE_SYSTEM_NAME Linux )
set ( CMAKE_C_COMPILER arm-linux-gnueabihf-gcc )
set ( CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++ )
set ( PKG_CONFIG_EXECUTABLE arm-linux-gnueabihf-pkg-config CACHE INTERNAL "" )

# CMAKE_C_FLAGS
set ( CMAKE_C_FLAGS_LIST
        -fPIC )
string ( REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS_LIST}" )
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE INTERNAL "" )

# CMAKE_C_FLAGS_DEBUG
set ( CMAKE_C_FLAGS_DEBUG_LIST
        -g
        -O0 )
string ( REPLACE ";" " " CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_LIST}" )
set ( CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE INTERNAL "" )

# CMAKE_C_FLAGS_RELEASE
set ( CMAKE_C_FLAGS_RELEASE_LIST
        -g
        -Os
        -DNDEBUG )
string ( REPLACE ";" " " CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_LIST}" )
set ( CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE INTERNAL "" )

# CMAKE_CXX_FLAGS
set ( CMAKE_CXX_FLAGS_LIST
        --std=c++14
        -fPIC
        -Wall
        -Werror
        -Wextra
        -fno-strict-overflow
        -fno-strict-aliasing
        -fstack-protector-all
        -Wlogical-op 
        # log4cplus
        -Wno-deprecated-declarations )
string ( REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_LIST}" )
set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE INTERNAL "" )

# CMAKE_CXX_FLAGS_DEBUG
set ( CMAKE_CXX_FLAGS_DEBUG_LIST
        -g
        -O0 )
string ( REPLACE ";" " " CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG_LIST}" )
set ( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}" CACHE INTERNAL "" )

# CMAKE_CXX_FLAGS_RELEASE
set ( CMAKE_CXX_FLAGS_RELEASE_LIST
        -g
        -Os
        -DNDEBUG )
string ( REPLACE ";" " " CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE_LIST}" )
set ( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" CACHE INTERNAL "" )

# https://stackoverflow.com/a/6331749/314015
# CMAKE_EXE_LINKER_FLAGS
set ( CMAKE_EXE_LINKER_FLAGS_LIST
        -Wl,-rpath
        -Wl,$ORIGIN
        -Wl,-z
        -Wl,origin )
string ( REPLACE ";" " " CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS_LIST}" )
set ( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "" )
# http://cmake.3232098.n2.nabble.com/CMAKE-EXE-LINKER-FLAGS-for-shared-libraries-td7087564.html
set ( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "" )
set ( CMAKE_SKIP_RPATH TRUE CACHE INTERNAL "" )

# variables for packages that are present, but do not have pkg-config support
set ( WILTON_PKGCONFIG_LIBDIR "-L/usr/lib/arm-linux-gnueabihf/" CACHE INTERNAL "" )
set ( WILTON_PKGCONFIG_INCLUDEDIR "-I/usr/include/ -I/usr/include/soci/ -I/usr/include/postgresql/" CACHE INTERNAL "" )
set ( log4cplus_VERSION "1.1.2-3" CACHE INTERNAL "" )
set ( asio_VERSION "1.10.6-3" CACHE INTERNAL "" )
set ( soci_VERSION "3.2.3-1" CACHE INTERNAL "" )

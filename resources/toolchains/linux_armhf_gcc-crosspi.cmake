# Copyright 2020, alex at staticlibs.net
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

set ( RPI_TOOLCHAIN_PREFIX /opt/cross-pi-gcc/bin/arm-linux-gnueabihf CACHE INTERNAL "" )

set ( CMAKE_SYSTEM_NAME Linux )
set ( CMAKE_SYSROOT /opt/cross-pi-gcc-sysroot CACHE INTERNAL "" )
set ( CMAKE_C_COMPILER ${RPI_TOOLCHAIN_PREFIX}-gcc )
set ( CMAKE_CXX_COMPILER ${RPI_TOOLCHAIN_PREFIX}-g++ )
set ( PKG_CONFIG_EXECUTABLE ${RPI_TOOLCHAIN_PREFIX}-pkg-config CACHE INTERNAL "" )

# CMAKE_C_FLAGS
set ( CMAKE_C_FLAGS_LIST
        -fPIC
        --sysroot=${CMAKE_SYSROOT} )
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
        # https://stackoverflow.com/a/1351737
        #-fstack-protector-all
        -Wlogical-op
        # duktape
        -Wno-implicit-fallthrough
        -Wno-format-truncation
        # log4cplus
        -Wno-deprecated-declarations
        # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=77728
        -Wno-psabi )
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
        -Wl,origin
        -Wl,-L${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/
        -Wl,-rpath-link
        -Wl,${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/ )
string ( REPLACE ";" " " CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS_LIST}" )
set ( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "" )
# http://cmake.3232098.n2.nabble.com/CMAKE-EXE-LINKER-FLAGS-for-shared-libraries-td7087564.html
set ( CMAKE_MODULE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "" )
set ( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "" )
set ( CMAKE_SKIP_RPATH TRUE CACHE INTERNAL "" )

# variables for packages that are present, but do not have pkg-config support
set ( WILTON_PKGCONFIG_LIBDIR "-L${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/" CACHE INTERNAL "" )
set ( WILTON_PKGCONFIG_INCLUDEDIR "-I${CMAKE_SYSROOT}/usr/include/" CACHE INTERNAL "" )
set ( asio_VERSION "1.12.2-1" CACHE INTERNAL "" )

set ( CMAKE_AR ${RPI_TOOLCHAIN_PREFIX}-ar CACHE INTERNAL "" )
set ( CMAKE_AS ${RPI_TOOLCHAIN_PREFIX}-as CACHE INTERNAL "" )
set ( CMAKE_LD ${RPI_TOOLCHAIN_PREFIX}-ld CACHE INTERNAL "" )
set ( CMAKE_NM ${RPI_TOOLCHAIN_PREFIX}-nm CACHE INTERNAL "" )
set ( CMAKE_OBJCOPY ${RPI_TOOLCHAIN_PREFIX}-objcopy CACHE INTERNAL "" )
set ( CMAKE_OBJDUMP ${RPI_TOOLCHAIN_PREFIX}-objdump CACHE INTERNAL "" )
set ( CMAKE_RANLIB ${RPI_TOOLCHAIN_PREFIX}-ranlib CACHE INTERNAL "" )
set ( CMAKE_STRIP ${RPI_TOOLCHAIN_PREFIX}-strip CACHE INTERNAL "" )
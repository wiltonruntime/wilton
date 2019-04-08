# Copyright 2019, alex at staticlibs.net
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

set ( RASPBIAN_TOOLCHAIN_DIR SPECIFY_ME_I_AM_RASPBIAN_TOOLCHAIN_DIR CACHE STRING "" )
set ( RASPBIAN_TOOLCHAIN_PREFIX ${RASPBIAN_TOOLCHAIN_DIR}/bin/arm-linux-gnueabihf CACHE INTERNAL "" )

set ( CMAKE_SYSTEM_NAME Linux )
set ( CMAKE_SYSROOT ${RASPBIAN_TOOLCHAIN_DIR}/arm-linux-gnueabihf/sysroot CACHE INTERNAL "" )
set ( CMAKE_C_COMPILER ${RASPBIAN_TOOLCHAIN_PREFIX}-gcc )
set ( CMAKE_CXX_COMPILER ${RASPBIAN_TOOLCHAIN_PREFIX}-g++ )
set ( PKG_CONFIG_EXECUTABLE ${RASPBIAN_TOOLCHAIN_PREFIX}-pkg-config CACHE INTERNAL "" )

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
        --std=c++11
        -fPIC
        -Wall
        -Werror
        -Wextra
        -fno-strict-overflow
        -fno-strict-aliasing
        -fstack-protector-all
        -Wlogical-op 
        # log4cplus
        -Wno-deprecated-declarations
        --sysroot=${CMAKE_SYSROOT} )
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
set ( asio_VERSION "1.10.6-3" CACHE INTERNAL "" )

set ( CMAKE_AR ${RASPBIAN_TOOLCHAIN_PREFIX}-ar CACHE INTERNAL "" )
set ( CMAKE_AS ${RASPBIAN_TOOLCHAIN_PREFIX}-as CACHE INTERNAL "" )
set ( CMAKE_LD ${RASPBIAN_TOOLCHAIN_PREFIX}-ld CACHE INTERNAL "" )
set ( CMAKE_NM ${RASPBIAN_TOOLCHAIN_PREFIX}-nm CACHE INTERNAL "" )
set ( CMAKE_OBJCOPY ${RASPBIAN_TOOLCHAIN_PREFIX}-objcopy CACHE INTERNAL "" )
set ( CMAKE_OBJDUMP ${RASPBIAN_TOOLCHAIN_PREFIX}-objdump CACHE INTERNAL "" )
set ( CMAKE_RANLIB ${RASPBIAN_TOOLCHAIN_PREFIX}-ranlib CACHE INTERNAL "" )
set ( CMAKE_STRIP ${RASPBIAN_TOOLCHAIN_PREFIX}-strip CACHE INTERNAL "" )
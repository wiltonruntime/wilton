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

# default to Release
set ( CMAKE_BUILD_TYPE "Release" CACHE STRING "Default build type" )

set ( CMAKE_SYSTEM_NAME Windows CACHE INTERNAL "" )
set ( CMAKE_C_COMPILER cl.exe )
set ( CMAKE_CXX_COMPILER cl.exe )
# see https://blogs.msdn.microsoft.com/vcblog/2012/10/08/windows-xp-targeting-with-c-in-visual-studio-2012/
set ( CMAKE_C_FLAGS "/D_USING_V110_SDK71_" CACHE INTERNAL "" )
set ( CMAKE_C_FLAGS_DEBUG "/D_DEBUG /MDd /Zi /Ob0 /Od" CACHE INTERNAL "" )
set ( CMAKE_C_FLAGS_RELEASE "/D NDEBUG /MD /Zi /O1" CACHE INTERNAL "" )
set ( CMAKE_CXX_FLAGS "/D_USING_V110_SDK71_ /W4 /WX /EHsc" CACHE INTERNAL "" )
set ( CMAKE_CXX_FLAGS_DEBUG "/D_DEBUG /MDd /Zi /Ob0 /Od /RTC1" CACHE INTERNAL "" )
set ( CMAKE_CXX_FLAGS_RELEASE "/D NDEBUG /MD /Zi /Zo /O1" CACHE INTERNAL "" )
#set ( CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:WINDOWS,5.01" CACHE INTERNAL "" )
set ( CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:CONSOLE,5.01" CACHE INTERNAL "" )
set ( CMAKE_EXE_LINKER_FLAGS_RELEASE "/DEBUG /OPT:REF /OPT:ICF /INCREMENTAL:NO" CACHE INTERNAL "" )
set ( CMAKE_SHARED_LINKER_FLAGS_RELEASE "/DEBUG /OPT:REF /OPT:ICF /INCREMENTAL:NO" CACHE INTERNAL "" )


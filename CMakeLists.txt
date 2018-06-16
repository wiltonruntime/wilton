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

# versioning
if ( DEFINED WILTON_RELEASE )
    # git describe --exact-match --tags HEAD : vYYYYMMDDB
    string ( SUBSTRING ${WILTON_RELEASE} 1 4 WILTON_VERSION_YEAR )
    string ( SUBSTRING ${WILTON_RELEASE} 1 2 WILTON_VERSION_YEAR_SHORT )
    string ( SUBSTRING ${WILTON_RELEASE} 5 2 WILTON_VERSION_MONTH )
    string ( SUBSTRING ${WILTON_RELEASE} 7 2 WILTON_VERSION_DAY )
    string ( SUBSTRING ${WILTON_RELEASE} 9 1 WILTON_VERSION_BUILD )
else ( )
    string ( TIMESTAMP WILTON_VERSION_YEAR "%Y" )
    string ( TIMESTAMP WILTON_VERSION_YEAR_SHORT "%y" )
    string ( TIMESTAMP WILTON_VERSION_MONTH "%m" )
    string ( TIMESTAMP WILTON_VERSION_DAY "%d" )
    set ( WILTON_VERSION_BUILD "0" CACHE STRING "" )
endif ( )
set ( WILTON_VERSION ${WILTON_VERSION_YEAR}${WILTON_VERSION_MONTH}${WILTON_VERSION_DAY}${WILTON_VERSION_BUILD} CACHE STRING "" )
set ( WILTON_VERSION_WIN ${WILTON_VERSION_YEAR_SHORT}.${WILTON_VERSION_MONTH}.${WILTON_VERSION_DAY}.${WILTON_VERSION_BUILD} CACHE STRING "" )
set ( WILTON_VERSION_EXE ${WILTON_VERSION_YEAR_SHORT},${WILTON_VERSION_MONTH},${WILTON_VERSION_DAY},${WILTON_VERSION_BUILD} CACHE STRING "" )

# toolchain setup
if ( NOT DEFINED STATICLIB_TOOLCHAIN )
    if ( WIN32 )
        if ( ${CMAKE_GENERATOR} MATCHES ".*Win64" )
            set ( STATICLIB_TOOLCHAIN "windows_amd64_msvc" CACHE STRING "" )
            set ( WILTON_INSTALLER_WIN64 "true" CACHE STRING "" )
            set ( WILTON_MSVCR_ARCH "x64" CACHE STRING "" )
            if ( NOT DEFINED WILTON_BUILD_FLAVOUR )
                set ( WILTON_BUILD_FLAVOUR "sdk81" CACHE STRING "" )
            endif ( )
        else ( )
            set ( STATICLIB_TOOLCHAIN "windows_i386_msvc" CACHE STRING "" )
            set ( WILTON_INSTALLER_WIN64 "false" CACHE STRING "" )
            set ( WILTON_MSVCR_ARCH "x86" CACHE STRING "" )
            if ( NOT DEFINED WILTON_BUILD_FLAVOUR )
                set ( WILTON_BUILD_FLAVOUR "sdk71" CACHE STRING "" )
            endif ( )
        endif ( )
    elseif ( APPLE)
        set ( STATICLIB_TOOLCHAIN "macosx_amd64_clang" CACHE STRING "" )
        set ( WILTON_BUILD_FLAVOUR "mavericks" CACHE STRING "" )
    elseif ( UNIX )
        set ( STATICLIB_TOOLCHAIN "linux_amd64_gcc" CACHE STRING "" )
        if ( NOT DEFINED WILTON_BUILD_FLAVOUR )
            set ( WILTON_BUILD_FLAVOUR "wheezy" CACHE STRING "" )
        endif ( )
    else ( )
        message ( FATAL_ERROR "Cannot find out toolchain to use, please specify [STATICLIB_TOOLCHAIN]" )
    endif ( )
endif ( )
if ( STATICLIB_TOOLCHAIN MATCHES "android_.+" )
    option ( ANDROID_SDK_ENABLE_LIBC_PRELOAD "Use libc_2.15 in LD_LIBRARY_PATH for running Android SDK" ON )
    if ( NOT DEFINED WILTON_BUILD_FLAVOUR )
        set ( WILTON_BUILD_FLAVOUR "r9d" CACHE STRING "" )
    endif ( )
endif ( )
set ( WILTON_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "" )
set ( STATICLIB_DEPS ${WILTON_DIR}/deps CACHE INTERNAL "" )
set ( STATICLIB_CMAKE ${STATICLIB_DEPS}/cmake CACHE INTERNAL "" )
set ( CMAKE_TOOLCHAIN_FILE ${WILTON_DIR}/resources/toolchains/${STATICLIB_TOOLCHAIN}-${WILTON_BUILD_FLAVOUR}.cmake CACHE INTERNAL "" )

# master project
project ( wilton CXX C )
include ( ${STATICLIB_CMAKE}/staticlibs_common.cmake )
set_property ( GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE )

# options
if ( STATICLIB_TOOLCHAIN MATCHES "windows_.+" )
    if ( NOT DEFINED WILTON_MSVCR_DIR )
        set ( WILTON_MSVCR_DIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/redist" CACHE STRING "" )
    endif ( )
    if ( NOT DEFINED WILTON_WINDDK71_DIR )
        set ( WILTON_WINDDK71_DIR "C:/WinDDK/7600.16385.1" CACHE STRING "" )
    endif ( )
endif ( )

# version file
configure_file ( ${WILTON_DIR}/resources/buildres/wilton.version
        ${CMAKE_CURRENT_BINARY_DIR}/wilton.version )
# doxygen file
configure_file ( ${WILTON_DIR}/resources/doxygen/Doxyfile
        ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile )

# supply missed pkg-config descriptors
if ( WILTON_BUILD_FLAVOUR MATCHES "wheezy" )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/log4cplus.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/log4cplus.pc )
elseif ( WILTON_BUILD_FLAVOUR MATCHES "fedora" )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/hpdf.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/hpdf.pc )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/soci.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/soci.pc )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/asio.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/asio.pc )
elseif ( WILTON_BUILD_FLAVOUR MATCHES "xenial" )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/asio.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/asio.pc )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/log4cplus.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/log4cplus.pc )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/soci.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/soci.pc )
elseif ( WILTON_BUILD_FLAVOUR MATCHES "el7" )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/asio.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/asio.pc )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/popt.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/popt.pc )
    configure_file ( ${WILTON_DIR}/resources/pkgconfig/soci.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/soci.pc )
endif ( )

# core
add_subdirectory ( ${WILTON_DIR}/core )

# engines
staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_duktape )
staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_rhino )

# modules
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_logging )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_crypto )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_zip )

staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_channel )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_cron )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_db )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_fs )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_ghc )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_http )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_loader )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_mustache )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_pdf )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_server )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_net )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_thread )
if ( STATICLIB_TOOLCHAIN MATCHES "android_.+" )
    # engines
    add_custom_target ( wilton_chakracore )
    add_custom_target ( wilton_jsc )
    add_custom_target ( wilton_mozjs )
    add_custom_target ( wilton_v8 )
    # modules
    add_custom_target ( wilton_cli )
    add_custom_target ( wilton_kiosk )
    add_custom_target ( wilton_process )
    add_custom_target ( wilton_serial )
    add_custom_target ( wilton_signal )
    add_custom_target ( wilton_usb )
    add_custom_target ( wilton_winservice )
endif ( )
if ( STATICLIB_TOOLCHAIN MATCHES "(windows|linux|macosx)_.+" )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_cli )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_process )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_signal )
endif ( )
if ( STATICLIB_TOOLCHAIN MATCHES "windows_.+" )
    # engines
    if ( STATICLIB_TOOLCHAIN MATCHES "windows_amd64_.+" )
        staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_chakra )
    else ( )
        add_custom_target ( wilton_chakra )
    endif ( )
    add_custom_target ( wilton_chakracore )
    add_custom_target ( wilton_jsc )
    add_custom_target ( wilton_mozjs )
    add_custom_target ( wilton_v8 )
    # modules
    add_custom_target ( wilton_kiosk )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_serial )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_usb )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_winservice )
endif ( )

if ( STATICLIB_TOOLCHAIN MATCHES "linux_.+" )
    # engines
    staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_jsc )
    if ( STATICLIB_TOOLCHAIN MATCHES "linux_amd64_.+" )
        staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_chakracore )
        staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_mozjs )
        staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_v8 )
    else ( )
        add_custom_target ( wilton_chakracore )
        add_custom_target ( wilton_mozjs )
        add_custom_target ( wilton_v8 )
    endif ( )
    # modules
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_kiosk )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_serial )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_usb )
    add_custom_target ( wilton_winservice )
endif ( )
if ( STATICLIB_TOOLCHAIN MATCHES "macosx_.+" )
    # engines
    add_custom_target ( wilton_chakracore )
    staticlib_add_subdirectory ( ${WILTON_DIR}/engines/wilton_jsc )
    add_custom_target ( wilton_mozjs )
    add_custom_target ( wilton_v8 )
    # modules
    add_custom_target ( wilton_kiosk )
    add_custom_target ( wilton_serial )
    add_custom_target ( wilton_usb )
    add_custom_target ( wilton_winservice )
endif ( )

add_custom_target ( nativelibs DEPENDS
        wilton_core
        # engines
        wilton_chakracore
        wilton_duktape
        wilton_jsc
        wilton_mozjs
        wilton_rhino
        wilton_v8
        # modules
        wilton_db
        wilton_channel
        wilton_cli
        wilton_cron
        wilton_crypto
        wilton_fs
        wilton_ghc
        wilton_http
        wilton_kiosk
        wilton_loader
        wilton_logging
        wilton_net
        wilton_mustache
        wilton_pdf
        wilton_process
        wilton_serial
        wilton_server
        wilton_signal
        wilton_thread
        wilton_usb
        wilton_zip )

add_custom_command ( OUTPUT std.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory js
        COMMAND jjs
                -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                -cp ${WILTON_DIR}/tools/closure-compiler/closure-compiler.jar
                ${WILTON_DIR}/tools/convertion-scripts/bundle-stdlib-modules.js
                -- ${WILTON_DIR}/js js
        COMMAND cd js && zip -qr9 js.zip *
        COMMAND ${CMAKE_COMMAND} -E rename
                ${CMAKE_CURRENT_BINARY_DIR}/js/js.zip
                ${CMAKE_CURRENT_BINARY_DIR}/std.wlib
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS nativelibs # just to preserve ordering
        COMMENT "Preparing JavaScript modules bundle ..." )

add_custom_command ( OUTPUT std.min.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory js
        COMMAND jjs
                -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                -cp ${WILTON_DIR}/tools/closure-compiler/closure-compiler.jar
                ${WILTON_DIR}/tools/convertion-scripts/bundle-stdlib-modules.js
                -- ${WILTON_DIR}/js js minified
        COMMAND cd js && zip -qr9 js.zip *
        COMMAND ${CMAKE_COMMAND} -E rename
                ${CMAKE_CURRENT_BINARY_DIR}/js/js.zip
                ${CMAKE_CURRENT_BINARY_DIR}/std.min.wlib
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS std.wlib
        COMMENT "Preparing JavaScript modules minified bundle ..." )

add_custom_target( stdlib DEPENDS std.wlib std.min.wlib )

add_custom_target ( examples 
        COMMAND ${CMAKE_COMMAND} -E remove_directory examples
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${WILTON_DIR}/js/examples
                examples
        COMMAND cd examples/binmod &&
                zip -qr9 binmod.zip *
        COMMAND ${CMAKE_COMMAND} -E rename
                ${CMAKE_CURRENT_BINARY_DIR}/examples/binmod/binmod.zip
                ${CMAKE_CURRENT_BINARY_DIR}/examples/binmod.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory
                examples/binmod
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing Examples directory ..." )

add_custom_target ( debuginfo
        COMMAND ${CMAKE_COMMAND} -E make_directory
                wilton_${WILTON_VERSION}_debuginfo
        # core
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/

        # engines
        # duktape
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_duktape${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # rhino
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_rhino${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/

        # modules
        # channel
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # cron
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # crypto
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_crypto${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # db
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # fs
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_fs${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # ghc
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_ghc${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # http
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_http${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # loader
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # logging
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # mustache
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_mustache${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # net
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # pdf
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_pdf${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # server
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_server${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # thread
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        # zip
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_zip${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                wilton_${WILTON_VERSION}_debuginfo/
        DEPENDS nativelibs
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing debuginfo bundle ..." )

if ( STATICLIB_TOOLCHAIN MATCHES "android_.+" )
    if ( STATICLIB_TOOLCHAIN MATCHES "android_armeabi_.+" )
        set ( ${PROJECT_NAME}_ANDROID_ARCH armeabi-v7a )
    elseif ( STATICLIB_TOOLCHAIN MATCHES "android_i386_.+" )
        set ( ${PROJECT_NAME}_ANDROID_ARCH x86 )
    else ( )
        message ( FATAL_ERROR "Cannot determine Android arch for toolchain: [${STATICLIB_TOOLCHAIN}]" )
    endif ( )

    if ( ANDROID_SDK_ENABLE_LIBC_PRELOAD )
        set ( ${PROJECT_NAME}_LIBC_PRELOAD_CMD LD_LIBRARY_PATH=${WILTON_DIR}/tools/android/libc6_2.15/lib/x86_64-linux-gnu/ CACHE INTERNAL "" )

    endif ( )

    add_custom_command ( OUTPUT wilton-android.jar
            COMMAND ${CMAKE_COMMAND} -E remove wilton-android.jar
            COMMAND cd ${WILTON_DIR}/jni &&
                    ${WILTON_DIR}/tools/maven/bin/mvn clean package -Dmaven.test.skip=true
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/jni/target/wilton-android.jar
                    wilton-android.jar
            COMMAND ${CMAKE_COMMAND} -E remove_directory lib
            COMMAND ${CMAKE_COMMAND} -E make_directory lib
            COMMAND ${CMAKE_COMMAND} -E make_directory lib/${${PROJECT_NAME}_ANDROID_ARCH}
            # gnustl
            COMMAND ${CMAKE_COMMAND} -E copy ${ANDROID_GNUSTL_SHARED_PATH}/libgnustl_shared.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libgnustl_shared.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libgnustl_shared.so
            # core
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_core.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_core.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_core.so

            # engines
            # duktape
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_duktape.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_duktape.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_duktape.so
            # rhino
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_rhino.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_rhino.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_rhino.so
 
            # modules
            # db
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_db.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_db.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_db.so
            # channel
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_channel.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_channel.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_channel.so
            # cron
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_cron.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_cron.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_cron.so
            # crypto
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_crypto.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_crypto.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_crypto.so
            # fs
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_fs.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_fs.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_fs.so
            # ghc
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_ghc.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_ghc.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_ghc.so
            # http
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_http.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_http.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_http.so
            # loader
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_loader.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_loader.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_loader.so
            # logging
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_logging.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_logging.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_logging.so
            # mustache
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_mustache.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_mustache.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_mustache.so
            # net
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_net.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_net.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_net.so
            # pdf
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_pdf.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_pdf.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_pdf.so
            # server
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_server.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_server.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_server.so
            # thread
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_thread.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_thread.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_thread.so
            # zip
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_zip.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_zip.so
            COMMAND jar uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_zip.so

            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS nativelibs
            COMMENT "Creating Android JAR ..." )
    add_custom_target ( android_jar DEPENDS wilton-android.jar )

    set ( ${PROJECT_NAME}_GRADLE_JVM_ARGS "-XX:MaxRAM=1024M -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -XX:+UseSerialGC" CACHE INTERNAL "" )

    add_custom_target ( android_apk
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${WILTON_DIR}/android/build
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${WILTON_DIR}/android/app/build
            COMMAND ${CMAKE_COMMAND} -E copy
                    std.min.wlib
                    ${WILTON_DIR}/android/app/src/main/assets/wilton.android/std.wlib
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    examples
                    ${WILTON_DIR}/android/app/src/main/assets/wilton.android/examples
            COMMAND ${CMAKE_COMMAND} -E make_directory
                    ${WILTON_DIR}/android/app/src/main/assets/wilton.android/wilton
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    ${WILTON_DIR}/js/wilton/test
                    ${WILTON_DIR}/android/app/src/main/assets/wilton.android/wilton/test
            COMMAND ${CMAKE_COMMAND} -E copy
                    wilton.version
                    ${WILTON_DIR}/android/app/src/main/assets/wilton.android/wilton.version
            COMMAND cd ${WILTON_DIR}/android &&
                    ${${PROJECT_NAME}_LIBC_PRELOAD_CMD}
                    ANDROID_HOME=${WILTON_DIR}/tools/android/sdk
                    ${WILTON_DIR}/tools/gradle/bin/gradle
                    -Dorg.gradle.java.home=${WILTON_DIR}/tools/linux/jdk8
                    -Dorg.gradle.jvmargs=${${PROJECT_NAME}_GRADLE_JVM_ARGS}
                    -Dorg.gradle.parallel=false
                    -Dorg.gradle.daemon=false
                    clean
                    assembleDebug
                    #--refresh-dependencies
            COMMAND ${CMAKE_COMMAND} -E copy
                ${WILTON_DIR}/android/app/build/outputs/apk/debug/app-debug.apk
                wilton_${WILTON_VERSION}.apk
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS stdlib android_jar examples
            COMMENT "Creating Android APK ..." )

elseif ( STATICLIB_TOOLCHAIN MATCHES "(windows|linux|macosx)_.+" )

    add_custom_target ( debuginfo_launcher
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}_debuginfo
            # cli
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_EXECUTABLE_PREFIX}wilton_cli${STATICLIB_DEBUGINFO_EXE_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # process
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_process${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # signal
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_signal${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_cli wilton_process wilton_signal )
    add_dependencies ( debuginfo debuginfo_launcher )

    add_custom_command ( OUTPUT ${WILTON_DIR}/jni/target/wilton-android.jar
            COMMAND ${WILTON_DIR}/tools/maven/bin/mvn clean package -Dmaven.test.skip=true
            WORKING_DIRECTORY ${WILTON_DIR}/jni
            COMMENT "Building wilton_rhino.jar ..." )
    add_custom_target ( wilton_rhino_jar_build DEPENDS ${WILTON_DIR}/jni/target/wilton-android.jar )
    
    add_custom_command ( OUTPUT wilton_rhino.jar            
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/jni/target/wilton-android.jar
                    wilton_rhino.jar
            # add FxApp classfile that cannot be compiled without JFX
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton/support/fx
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/jni/src/main/java/wilton/support/fx/FxApp.class
                    wilton/support/fx/FxApp.class
            COMMAND jar uf wilton_rhino.jar wilton/support/fx/FxApp.class
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_rhino_jar_build
            COMMENT "Bundling wilton_rhino.jar ..." )
    add_custom_target ( wilton_rhino_jar DEPENDS wilton_rhino.jar )

    add_custom_target ( dist
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/conf
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/devel
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/log
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/work
            # core
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/core/include/wilton/wilton.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton.h
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/core/include/wilton/wiltoncall.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wiltoncall.h

            # engines
            # duktape
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_duktape${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_duktape${CMAKE_SHARED_LIBRARY_SUFFIX}
            # rhino
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_rhino${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_rhino${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    wilton_rhino.jar
                    wilton_${WILTON_VERSION}/bin/wilton_rhino.jar


            # modules
            # channel
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_channel/include/wilton/wilton_channel.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_channel.h
            # cron
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_cron/include/wilton/wilton_cron.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_cron.h
            # crypto
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_crypto${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_crypto${CMAKE_SHARED_LIBRARY_SUFFIX}
            # db
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_db/include/wilton/wilton_db.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_db.h
            # fs
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_fs${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_fs${CMAKE_SHARED_LIBRARY_SUFFIX}
            # ghc
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_ghc${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_ghc${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_ghc/include/wilton/wilton_ghc.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_ghc.h
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_ghc/resources/wilton_ghcshim.c
                    wilton_${WILTON_VERSION}/devel/ghc/wilton_ghcshim.c
            # http
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_http${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_http${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_http/include/wilton/wilton_http.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_http.h
            # loader
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_loader/include/wilton/wilton_loader.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_loader.h
            # logging
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_logging/include/wilton/wilton_logging.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_logging.h
            # mustache
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_mustache${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_mustache${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_mustache/include/wilton/wilton_mustache.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_mustache.h
            # net
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_net/include/wilton/wilton_net.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_net.h
            # pdf
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_pdf${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_pdf${CMAKE_SHARED_LIBRARY_SUFFIX}
            # process
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_process${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_process${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_process/include/wilton/wilton_process.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_process.h
            # signal
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_signal${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_signal${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_signal/include/wilton/wilton_signal.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_signal.h
            # server
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_server${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_server${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_server/include/wilton/wilton_server.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_server.h
            # thread
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_thread/include/wilton/wilton_thread.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_thread.h
            # zip
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_zip${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_zip${CMAKE_SHARED_LIBRARY_SUFFIX}

            # other resources
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/wilton_cli${CMAKE_EXECUTABLE_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/wilton${CMAKE_EXECUTABLE_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    std.wlib
                    wilton_${WILTON_VERSION}/std.wlib
            COMMAND ${CMAKE_COMMAND} -E copy
                    std.min.wlib
                    wilton_${WILTON_VERSION}/std.min.wlib
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    examples
                    wilton_${WILTON_VERSION}/examples
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_cli/resources/one-liner-template.js
                    wilton_${WILTON_VERSION}/conf/one-liner-template.js
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/js/examples/winservice/config.json
                    wilton_${WILTON_VERSION}/conf/config.json
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/resources/toolchains/${STATICLIB_TOOLCHAIN}-${WILTON_BUILD_FLAVOUR}.cmake
                    wilton_${WILTON_VERSION}/devel/${STATICLIB_TOOLCHAIN}.cmake
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/resources/installer/.keep
                    wilton_${WILTON_VERSION}/log/.keep
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/resources/installer/.keep
                    wilton_${WILTON_VERSION}/work/.keep
            COMMAND ${CMAKE_COMMAND} -E copy
                    wilton.version
                    wilton_${WILTON_VERSION}/conf/wilton.version  
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS debuginfo stdlib examples wilton_rhino_jar
            COMMENT "Creating distribution at [${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}] ..." )

    add_custom_target ( dist_debug
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    wilton_${WILTON_VERSION}_debuginfo
                    wilton_${WILTON_VERSION}/bin
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS debuginfo dist
            COMMENT "Adding debuginfo to the distibution ..." )

    add_custom_target ( dist_unversioned
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    wilton_${WILTON_VERSION}
                    wilton_dist
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS dist
            COMMENT "Creaing unversioned distribution ..." )

    add_custom_target ( test_js
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on default JavaScript engine ..." )

    add_custom_target ( test_chakracore
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j chakracore
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j chakracore
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j chakracore
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j chakracore
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j chakracore
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on ChakraCore JavaScript engine ..." )

    add_custom_target ( test_duktape
#            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j duktape
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j duktape
#            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j duktape
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j duktape
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j duktape
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on Duktape JavaScript engine ..." )

    add_custom_target ( test_jsc
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j jsc
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j jsc
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j jsc
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j jsc
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j jsc
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on JSC JavaScript engine ..." )

    add_custom_target ( test_mozjs
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j mozjs
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j mozjs
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j mozjs
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j mozjs
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j mozjs
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on MozJS JavaScript engine ..." )

    add_custom_target ( test_v8
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j v8
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j v8
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j v8
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j v8
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j v8
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on V8 JavaScript engine ..." )

    add_custom_target ( test_rhino
#            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j rhino
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j rhino
            # requires rhino 1.7.7.2+
            # COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j rhino
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j rhino
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j rhino
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on Rhino JavaScript engine ..." )

    add_custom_target ( test_nashorn
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j nashorn
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runNodeTests.js -m ${WILTON_DIR}/js -j nashorn
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runMathJsTests.js -m ${WILTON_DIR}/js -j nashorn
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -j nashorn
            COMMAND bin/wilton ${WILTON_DIR}/js/test-runners/runSanityTests.js -m std.min.wlib -j nashorn
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests on Nashorn JavaScript engine ..." )

    add_custom_target ( test_jvm
            COMMAND ${WILTON_DIR}/tools/maven/bin/mvn test
            WORKING_DIRECTORY ${WILTON_DIR}/jni
            DEPENDS dist
            COMMENT "Running Java tests ..." )

    add_custom_target ( test_all DEPENDS test_js test_duktape )

endif ( )

if ( STATICLIB_TOOLCHAIN MATCHES "windows_.+" )

    add_custom_target ( debuginfo_windows_generic
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}_debuginfo
            # serial
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/wilton_serial.pdb
                    wilton_${WILTON_VERSION}_debuginfo/
            # usb
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/wilton_usb.pdb
                    wilton_${WILTON_VERSION}_debuginfo/
            # winservice
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/wilton_winservice.pdb
                    wilton_${WILTON_VERSION}_debuginfo/
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_serial wilton_usb wilton_winservice )

    add_custom_target ( dist_windows_generic
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            # serial
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_serial/include/wilton/wilton_serial.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_serial.h
            # usb
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_usb/include/wilton/wilton_usb.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_usb.h
            # winservice
            COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/wilton_winservice.exe
                wilton_${WILTON_VERSION}/bin/wilton_winservice.exe
            COMMAND ${CMAKE_COMMAND} -E copy
                ${WILTON_MSVCR_DIR}/${WILTON_MSVCR_ARCH}/Microsoft.VC120.CRT/msvcr120.dll
                wilton_${WILTON_VERSION}/bin/msvcr120.dll
            COMMAND ${CMAKE_COMMAND} -E copy
                ${WILTON_MSVCR_DIR}/${WILTON_MSVCR_ARCH}/Microsoft.VC120.CRT/msvcp120.dll
                wilton_${WILTON_VERSION}/bin/msvcp120.dll
            # todo: think about import libs for other modules
            COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/wilton_core.lib
                wilton_${WILTON_VERSION}/devel/wilton_core.lib
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_serial wilton_usb wilton_winservice debuginfo_windows_generic )

    add_custom_target ( debuginfo_windows_amd64
            # chakra
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/wilton_chakra.pdb
                    wilton_${WILTON_VERSION}_debuginfo/
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_chakra debuginfo_windows_generic )

    add_custom_target ( dist_windows_amd64
            # chakra
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/wilton_chakra.dll
                    wilton_${WILTON_VERSION}/bin/wilton_chakra.dll
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_chakra dist_windows_generic debuginfo_windows_amd64 )

    add_custom_target ( debuginfo_windows DEPENDS debuginfo_windows_generic )
    add_custom_target ( dist_windows DEPENDS dist_windows_generic debuginfo_windows )

    # no chakra on winxp
    if ( STATICLIB_TOOLCHAIN MATCHES "windows_amd64_.+" )
        add_dependencies ( debuginfo_windows debuginfo_windows_amd64 )
        add_dependencies ( dist_windows dist_windows_amd64 )
    endif ( )

    add_dependencies ( debuginfo debuginfo_windows )
    add_dependencies ( dist dist_windows )

    add_custom_target ( dist_windows_jre
            COMMAND if exist jre rd /s /q jre
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    ${WILTON_DIR}/tools/windows/jdk8_64/jre
                    jre
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}
            DEPENDS dist )

    configure_file ( 
            ${WILTON_DIR}/resources/installer/installer.json
            ${CMAKE_CURRENT_BINARY_DIR}/installer.json )

    add_custom_target ( installer
            COMMAND ${CMAKE_COMMAND} -E remove wilton_${WILTON_VERSION}.wxs
            COMMAND java
                    -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1
                    -jar ${WILTON_DIR}/tools/windows/wixgen/wixgen.jar
                    wilton_${WILTON_VERSION}
                    -c installer.json
                    -o wilton_${WILTON_VERSION}.wxs
            COMMAND ${WILTON_DIR}/tools/windows/wix/bin/candle -v -nologo wilton_${WILTON_VERSION}.wxs
            COMMAND ${WILTON_DIR}/tools/windows/wix/bin/light
                    -v -nologo -sw1076 -sval -ext WixUIExtension -ext WixUtilExtension
                    wilton_${WILTON_VERSION}.wixobj
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS dist
            COMMENT "Creating MSI at [${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}.msi] ..." )

elseif ( STATICLIB_TOOLCHAIN MATCHES "linux_.+" )

    add_custom_target ( debuginfo_linux
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}_debuginfo
            # engines
            # jsc
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # modules
            # kiosk
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_kiosk${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # serial
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # usb
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_jsc wilton_kiosk wilton_serial wilton_usb )
    add_dependencies ( debuginfo debuginfo_linux )
    add_custom_target ( debuginfo_linux_amd64 
            # chakracore
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_chakracore${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # mozjs
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_mozjs${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            # v8 
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_v8${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_chakracore wilton_mozjs wilton_v8 debuginfo_linux )
    if ( STATICLIB_TOOLCHAIN MATCHES "linux_amd64_.+" )
        add_dependencies ( debuginfo debuginfo_linux_amd64 )
    endif ( )

    add_custom_target ( dist_linux
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            # engines
            # jsc
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
            # modules
            # kiosk
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_kiosk${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_kiosk${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_kiosk/include/wilton/wilton_kiosk.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_kiosk.h
            # serial
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_serial/include/wilton/wilton_serial.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_serial.h
            # usb
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_usb/include/wilton/wilton_usb.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_usb.h
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_chakracore wilton_jsc wilton_mozjs wilton_kiosk wilton_serial wilton_usb wilton_v8 debuginfo_linux )
    add_dependencies ( dist dist_linux )

    add_custom_target ( dist_linux_amd64
            # icu
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}icuuc${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}icuuc${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}icui18n${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}icui18n${CMAKE_SHARED_LIBRARY_SUFFIX}
            # chakracore
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}ChakraCore${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}ChakraCore${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_chakracore${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_chakracore${CMAKE_SHARED_LIBRARY_SUFFIX}
            # mozjs
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}mozjs-52${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}mozjs-52${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_mozjs${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_mozjs${CMAKE_SHARED_LIBRARY_SUFFIX}
            # v8
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}v8${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}v8${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}v8_libbase${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}v8_libbase${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}v8_libplatform${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}v8_libplatform${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_v8${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_v8${CMAKE_SHARED_LIBRARY_SUFFIX}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_chakracore wilton_mozjs wilton_v8 dist_linux )
    if ( STATICLIB_TOOLCHAIN MATCHES "linux_amd64_.+" )
        add_dependencies ( dist dist_linux_amd64 )
    endif ( )

    add_custom_target ( dist_linux_jre
            COMMAND rm -f jre
            COMMAND ln -s ${WILTON_DIR}/tools/linux/jdk8/jre
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}
            DEPENDS dist )

    add_custom_target ( test_all_jvm DEPENDS test_all dist_linux_jre test_jvm test_rhino test_nashorn )
    add_dependencies ( test_all test_chakracore )
    add_dependencies ( test_all test_mozjs )
    add_dependencies ( test_all test_v8 )
    add_dependencies ( test_jvm dist_linux_jre )
    add_dependencies ( test_rhino dist_linux_jre )
    add_dependencies ( test_nashorn dist_linux_jre )

    add_custom_target ( docs
            COMMAND ${CMAKE_COMMAND} -E remove_directory doxy
            COMMAND ${CMAKE_COMMAND} -E remove_directory docs
            COMMAND ${CMAKE_COMMAND} -E make_directory docs
            COMMAND jjs
                    -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                    ${WILTON_DIR}/resources/doxygen/generate-doxy.js
                    ${WILTON_DIR}/js/wilton doxy
            COMMAND doxygen
            # poor man's WARN_AS_ERROR
            COMMAND [ ! -s doxygen_warnings.txt ]
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating documentation at [${CMAKE_CURRENT_BINARY_DIR}/docs] ..." )

elseif ( STATICLIB_TOOLCHAIN MATCHES "macosx_.+" )

    add_custom_target ( debuginfo_macosx
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}_debuginfo
            # jsc
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${STATICLIB_DEBUGINFO_SHARED_SUFFIX}
                    wilton_${WILTON_VERSION}_debuginfo/
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_jsc )
    add_dependencies ( debuginfo debuginfo_macosx )

    add_custom_target ( dist_macosx
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_jsc debuginfo_macosx )
    add_dependencies ( dist dist_macosx )

endif ( )

if ( STATICLIB_TOOLCHAIN MATCHES "(linux|macosx)_.+" )

    set ( ${PROJECT_NAME}_VGOPTS 
            --leak-check=yes --show-reachable=yes --track-origins=yes --error-exitcode=42 --track-fds=yes
            --suppressions=${WILTON_DIR}/resources/valgrind/asio.supp
            --suppressions=${WILTON_DIR}/resources/valgrind/openssl.supp
            --suppressions=${WILTON_DIR}/resources/valgrind/popt.supp 
            --suppressions=${WILTON_DIR}/resources/valgrind/wilton_dyload.supp 
        CACHE INTERNAL "" )

    add_custom_target ( valgrind
            COMMAND valgrind ${${PROJECT_NAME}_VGOPTS}
                    ./bin/wilton ./examples/binaryModule.js -b ./examples/binmod.wlib -j duktape
            COMMAND valgrind ${${PROJECT_NAME}_VGOPTS}
                    ./bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ../../js -j duktape
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running valgrind ..." )
endif ( )

# benchmarks

option ( WILTON_ENABLE_BENCHMARKS "Enable building the benchmarks" OFF )

if ( WILTON_ENABLE_BENCHMARKS )
    add_subdirectory ( bench )
endif ( )

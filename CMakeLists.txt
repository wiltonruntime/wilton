
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
        if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
            set ( STATICLIB_TOOLCHAIN "windows_amd64_msvc" CACHE STRING "" )
            if ( NOT DEFINED WILTON_BUILD_FLAVOUR )
                set ( WILTON_BUILD_FLAVOUR "sdk81" CACHE STRING "" )
            endif ( )
        else ( )
            set ( STATICLIB_TOOLCHAIN "windows_i386_msvc" CACHE STRING "" )
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

# modules
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_logging )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_channel )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_cron )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_db )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_duktape )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_fs )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_http )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_loader )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_net )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_pdf )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_rhino )
staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_thread )
if ( STATICLIB_TOOLCHAIN MATCHES "android_.+" )
    add_custom_target ( wilton_cli )
    add_custom_target ( wilton_jsc )
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
    add_custom_target ( wilton_jsc )
    add_custom_target ( wilton_serial )
    add_custom_target ( wilton_usb )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_winservice )
endif ( )
if ( STATICLIB_TOOLCHAIN MATCHES "linux_.+" )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_jsc )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_serial )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_usb )
    add_custom_target ( wilton_winservice )
endif ( )
if ( STATICLIB_TOOLCHAIN MATCHES "macosx_.+" )
    staticlib_add_subdirectory ( ${WILTON_DIR}/modules/wilton_jsc )
    add_custom_target ( wilton_serial )
    add_custom_target ( wilton_usb )
    add_custom_target ( wilton_winservice )
endif ( )

# platform tools
set ( TOOLS_JAVA java )
set ( TOOLS_JJS jjs )
set ( TOOLS_JAR jar )
set ( TOOLS_ZIP zip )
if ( STATICLIB_TOOLCHAIN MATCHES "windows_.+" )
    set ( TOOLS_JAVA ${WILTON_DIR}/tools/windows/jdk8/bin/java.exe )
    set ( TOOLS_JJS ${WILTON_DIR}/tools/windows/jdk8/bin/jjs.exe )
    set ( TOOLS_JAR ${WILTON_DIR}/tools/windows/jdk8/bin/jar.exe )
    set ( TOOLS_ZIP ${WILTON_DIR}/tools/windows/zip/zip.exe )
endif ( )

add_custom_command ( OUTPUT std.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory js
        COMMAND ${TOOLS_JJS}
                -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                -cp ${WILTON_DIR}/tools/closure-compiler/closure-compiler.jar
                ${WILTON_DIR}/tools/convertion-scripts/minify-modules.js
                -- ${WILTON_DIR}/js js
        COMMAND cd js && ${TOOLS_ZIP} -qr9 js.zip *
        COMMAND ${CMAKE_COMMAND} -E rename js/js.zip std.wlib
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing JavaScript modules bundle ..." )

add_custom_target( stdlib DEPENDS std.wlib )

add_custom_target ( nativelibs DEPENDS
        wilton_core
        wilton_db
        wilton_duktape
        wilton_channel
        wilton_cli
        wilton_cron
        wilton_fs
        wilton_jsc
        wilton_http
        wilton_loader
        wilton_logging
        wilton_net
        wilton_pdf
        wilton_process
        wilton_rhino
        wilton_serial
        wilton_signal
        wilton_thread
        wilton_usb )

add_custom_target ( examples 
        COMMAND ${CMAKE_COMMAND} -E remove_directory examples
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${WILTON_DIR}/js/examples
                examples
        COMMAND cd examples/binmod &&
                ${TOOLS_ZIP} -qr9 binmod.zip *
        COMMAND ${CMAKE_COMMAND} -E rename
                examples/binmod/binmod.zip
                examples/binmod.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory
                examples/binmod
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing Examples directory ..." )

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
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libgnustl_shared.so
            # core
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_core.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_core.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_core.so
            # db
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_db.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_db.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_db.so
            # duktape
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_duktape.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_duktape.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_duktape.so
            # channel
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_channel.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_channel.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_channel.so
            # cron
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_cron.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_cron.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_cron.so
            # fs    
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_fs.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_fs.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_fs.so
            # http
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_http.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_http.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_http.so
            # loader
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_loader.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_loader.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_loader.so
            # logging
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_logging.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_logging.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_logging.so
            # net
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_net.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_net.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_net.so
            # pdf
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_pdf.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_pdf.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_pdf.so
            # rhino
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_rhino.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_rhino.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_rhino.so
            # thread
            COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libwilton_thread.so lib/${${PROJECT_NAME}_ANDROID_ARCH}/
            COMMAND ${CMAKE_STRIP} lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_thread.so
            COMMAND ${TOOLS_JAR} uf wilton-android.jar lib/${${PROJECT_NAME}_ANDROID_ARCH}/libwilton_thread.so

            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS nativelibs
            COMMENT "Creating Android JAR ..." )
    add_custom_target ( android_jar DEPENDS wilton-android.jar )

    set ( ${PROJECT_NAME}_GRADLE_JVM_ARGS "-XX:MaxRAM=1024M -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -XX:+UseSerialGC" CACHE INTERNAL "" )

    add_custom_target ( android_apk
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${WILTON_DIR}/android/build
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${WILTON_DIR}/android/app/build
            COMMAND ${CMAKE_COMMAND} -E copy
                    std.wlib
                    ${WILTON_DIR}/android/app/src/main/assets/net.wiltontoolkit.android/
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    examples
                    ${WILTON_DIR}/android/app/src/main/assets/net.wiltontoolkit.android/examples
            COMMAND ${CMAKE_COMMAND} -E make_directory
                    ${WILTON_DIR}/android/app/src/main/assets/net.wiltontoolkit.android/wilton
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    ${WILTON_DIR}/js/wilton/test
                    ${WILTON_DIR}/android/app/src/main/assets/net.wiltontoolkit.android/wilton/test
            COMMAND ${CMAKE_COMMAND} -E copy
                    wilton.version
                    ${WILTON_DIR}/android/app/src/main/assets/net.wiltontoolkit.android/wilton.version
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

    add_custom_target ( dist
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/conf
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/devel
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/log
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/work
            # core
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                    ${WILTON_DIR}/core/include
                    wilton_${WILTON_VERSION}/devel/include
            # channel
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_channel/include/wilton/wilton_channel.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_channel.h
            # cron
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_cron/include/wilton/wilton_cron.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_cron.h
            # db
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_db/include/wilton/wilton_db.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_db.h
            # duktape
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_duktape${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_duktape${CMAKE_SHARED_LIBRARY_SUFFIX}
            # fs
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_fs${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_fs${CMAKE_SHARED_LIBRARY_SUFFIX}
            # http
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_http${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_http${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_http/include/wilton/wilton_http.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_http.h
            # loader
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_loader/include/wilton/wilton_loader.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_loader.h
            # logging
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_logging/include/wilton/wilton_logging.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_logging.h
            # net
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_net/include/wilton/wilton_net.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_net.h
            # pdf
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_pdf${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_pdf${CMAKE_SHARED_LIBRARY_SUFFIX}
            # process
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_process${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_process${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_process/include/wilton/wilton_process.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_process.h
            # rhino
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_rhino${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_rhino${CMAKE_SHARED_LIBRARY_SUFFIX}
            # signal
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_signal${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_signal${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_signal/include/wilton/wilton_signal.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_signal.h
            # thread
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_thread/include/wilton/wilton_thread.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_thread.h
            # other resources
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/wilton_cli${CMAKE_EXECUTABLE_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/wilton${CMAKE_EXECUTABLE_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    std.wlib
                    wilton_${WILTON_VERSION}/std.wlib
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
            DEPENDS nativelibs stdlib examples
            COMMENT "Creating distribution at [${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}] ..." )

    add_custom_target ( jstest
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js
            COMMAND bin/wilton ${WILTON_DIR}/js/wilton/test/index.js -m ${WILTON_DIR}/js -j duktape
            COMMAND bin/wilton ${WILTON_DIR}/core/test/scripts/runNodeTests.js -m ${WILTON_DIR}/js
            COMMAND bin/wilton ${WILTON_DIR}/core/test/scripts/runNodeTests.js -m ${WILTON_DIR}/js -j duktape
            COMMAND cd ${WILTON_DIR}/jni && ${WILTON_DIR}/tools/maven/bin/mvn clean test
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            DEPENDS dist
            COMMENT "Running tests ..." )

endif ( )

if ( STATICLIB_TOOLCHAIN MATCHES "windows_.+" )

    add_custom_target ( dist_windows
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin            
            COMMAND ${CMAKE_COMMAND} -E copy
                bin/wilton_winservice.exe
                wilton_${WILTON_VERSION}/bin/wilton_winservice.exe
            COMMAND ${CMAKE_COMMAND} -E copy
                ${WILTON_DIR}/tools/windows/vs2013e/VC/redist/x86/Microsoft.VC120.CRT/msvcr120.dll
                wilton_${WILTON_VERSION}/bin/msvcr120.dll
            COMMAND ${CMAKE_COMMAND} -E copy
                ${WILTON_DIR}/tools/windows/vs2013e/VC/redist/x86/Microsoft.VC120.CRT/msvcp120.dll
                wilton_${WILTON_VERSION}/bin/msvcp120.dll
            COMMAND ${CMAKE_COMMAND} -E copy
                bin/wilton_core.lib
                wilton_${WILTON_VERSION}/devel/wilton_core.lib
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_winservice )
    add_dependencies ( dist dist_windows )

    configure_file ( 
            ${WILTON_DIR}/resources/installer/installer.json
            ${CMAKE_CURRENT_BINARY_DIR}/installer.json )

    add_custom_target ( installer
            COMMAND ${CMAKE_COMMAND} -E remove wilton_${WILTON_VERSION}.wxs
            COMMAND ${TOOLS_JAVA}
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

    add_custom_target ( dist_linux
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
            # serial
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_serial${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_serial/include/wilton/wilton_serial.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_serial.h
            # usb
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${WILTON_DIR}/modules/wilton_usb/include/wilton/wilton_usb.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_usb.h
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_jsc wilton_serial wilton_usb )
    add_dependencies ( dist dist_linux )

    add_custom_target ( docs
            COMMAND ${CMAKE_COMMAND} -E remove_directory doxy
            COMMAND ${CMAKE_COMMAND} -E remove_directory docs
            COMMAND ${CMAKE_COMMAND} -E make_directory docs
            COMMAND ${TOOLS_JJS}
                    -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                    ${WILTON_DIR}/resources/doxygen/generate-doxy.js
                    ${WILTON_DIR}/js/wilton doxy
            COMMAND doxygen
            # poor man's WARN_AS_ERROR
            COMMAND [ ! -s doxygen_warnings.txt ]
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating documentation at [${CMAKE_CURRENT_BINARY_DIR}/docs] ..." )

elseif ( STATICLIB_TOOLCHAIN MATCHES "macosx_.+" )

    add_custom_target ( dist_macosx
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_jsc${CMAKE_SHARED_LIBRARY_SUFFIX}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS wilton_jsc )
    add_dependencies ( dist dist_macosx )

endif ( )

if ( STATICLIB_TOOLCHAIN MATCHES "(linux|macosx)_.+" )

    set ( ${PROJECT_NAME}_VGOPTS 
            --leak-check=yes --show-reachable=yes --track-origins=yes --error-exitcode=42 --track-fds=yes
            --suppressions=${WILTON_DIR}/deps/cmake/resources/valgrind/openssl_malloc.supp
            --suppressions=${WILTON_DIR}/deps/cmake/resources/valgrind/popt_poptGetNextOpt.supp 
            --suppressions=${WILTON_DIR}/resources/valgrind/wilton_dyload.supp 
            --suppressions=${WILTON_DIR}/resources/valgrind/wilton_http.supp
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


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
    elseif ( UNIX )
        set ( STATICLIB_TOOLCHAIN "linux_amd64_gcc" CACHE STRING "" )
        if ( NOT DEFINED WILTON_BUILD_FLAVOUR )
            set ( WILTON_BUILD_FLAVOUR "wheezy" CACHE STRING "" )
        endif ( )
    else ( )
        message ( FATAL_ERROR "Cannot find out toolchain to use, please specify [STATICLIB_TOOLCHAIN]" )
    endif ( )
endif ( )
set ( STATICLIB_DEPS ${CMAKE_CURRENT_LIST_DIR}/deps CACHE INTERNAL "" )
set ( STATICLIB_CMAKE ${STATICLIB_DEPS}/cmake CACHE INTERNAL "" )
set ( CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/resources/toolchains/${STATICLIB_TOOLCHAIN}-${WILTON_BUILD_FLAVOUR}.cmake CACHE INTERNAL "" )

# master project
project ( wilton CXX C )
set ( WILTON_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "" )
include ( ${STATICLIB_CMAKE}/staticlibs_common.cmake )

# version file
configure_file ( ${WILTON_DIR}/resources/buildres/wilton.version
        ${CMAKE_CURRENT_BINARY_DIR}/wilton.version )
# doxygen file
configure_file ( ${WILTON_DIR}/resources/doxygen/Doxyfile
        ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile )

# supply missed pkg-config descriptor
if ( WILTON_BUILD_FLAVOUR MATCHES "wheezy" )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/log4cplus.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/log4cplus.pc )
elseif ( WILTON_BUILD_FLAVOUR MATCHES "fedora" )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/hpdf.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/hpdf.pc )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/soci.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/soci.pc )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/asio.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/asio.pc )
elseif ( WILTON_BUILD_FLAVOUR MATCHES "xenial" )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/asio.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/asio.pc )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/log4cplus.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/log4cplus.pc )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/soci.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/soci.pc )
elseif ( WILTON_BUILD_FLAVOUR MATCHES "el7" )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/asio.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/asio.pc )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/popt.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/popt.pc )
    configure_file ( ${CMAKE_CURRENT_LIST_DIR}/resources/pkgconfig/soci.pc
            ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pkgconfig/soci.pc )
endif ( )

# core
add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/core )

# modules
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_logging )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_cli )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_channel )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_cron )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_db )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_duktape )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_fs )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_http )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_loader )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_net )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_pdf )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_process )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_rhino )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_signal )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_thread )
if ( STATICLIB_TOOLCHAIN MATCHES "windows_[^_]+_[^_]+" )
    add_custom_target ( wilton_jsc )
    add_custom_target ( wilton_serial )
    add_custom_target ( wilton_usb )
    staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_winservice )
else ( )
    staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_jsc )
    staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_serial )
    staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_usb )
    add_custom_target ( wilton_winservice )
endif ( )

# platform tools
set ( TOOLS_JAVA java )
set ( TOOLS_JJS jjs )
set ( TOOLS_ZIP zip )
if ( STATICLIB_TOOLCHAIN MATCHES "windows_[^_]+_[^_]+" )
    set ( TOOLS_JAVA ${CMAKE_CURRENT_LIST_DIR}/tools/windows/jdk8/bin/java.exe )
    set ( TOOLS_JJS ${CMAKE_CURRENT_LIST_DIR}/tools/windows/jdk8/bin/jjs.exe )
    set ( TOOLS_ZIP ${CMAKE_CURRENT_LIST_DIR}/tools/windows/zip/zip.exe )
endif ( )

add_custom_command ( OUTPUT std.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory js
        COMMAND ${TOOLS_JJS}
                -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                -cp ${CMAKE_CURRENT_LIST_DIR}/tools/closure-compiler/closure-compiler.jar
                ${CMAKE_CURRENT_LIST_DIR}/tools/convertion-scripts/minify-modules.js
                -- ${CMAKE_CURRENT_LIST_DIR}/js js
        COMMAND cd js && ${TOOLS_ZIP} -qr9 js.zip *
        COMMAND ${CMAKE_COMMAND} -E rename js/js.zip std.wlib
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing JavaScript modules bundle ..." )

add_custom_target( stdlib DEPENDS std.wlib )

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
                ${CMAKE_CURRENT_LIST_DIR}/core/include
                wilton_${WILTON_VERSION}/devel/include
        # channel
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_channel${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_channel/include/wilton/wilton_channel.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_channel.h
        # cron
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_cron${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_cron/include/wilton/wilton_cron.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_cron.h
        # db
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_db/include/wilton/wilton_db.h
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
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_http/include/wilton/wilton_http.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_http.h
        # loader
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_loader${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_loader/include/wilton/wilton_loader.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_loader.h
        # logging
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_logging${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_logging/include/wilton/wilton_logging.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_logging.h
        # net
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_net${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_net/include/wilton/wilton_net.h
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
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_process/include/wilton/wilton_process.h
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
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_signal/include/wilton/wilton_signal.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_signal.h
        # thread
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_thread${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_thread/include/wilton/wilton_thread.h
                wilton_${WILTON_VERSION}/devel/include/wilton/wilton_thread.h
        # other resources
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/wilton_cli${CMAKE_EXECUTABLE_SUFFIX}
                wilton_${WILTON_VERSION}/bin/wilton${CMAKE_EXECUTABLE_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                std.wlib
                wilton_${WILTON_VERSION}/std.wlib
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${CMAKE_CURRENT_LIST_DIR}/js/examples
                wilton_${WILTON_VERSION}/examples
        COMMAND cd wilton_${WILTON_VERSION}/examples/binmod &&
                ${TOOLS_ZIP} -qyr9 binmod.zip *
        COMMAND ${CMAKE_COMMAND} -E rename
                wilton_${WILTON_VERSION}/examples/binmod/binmod.zip
                wilton_${WILTON_VERSION}/examples/binmod.wlib
        COMMAND ${CMAKE_COMMAND} -E remove_directory
                wilton_${WILTON_VERSION}/examples/binmod
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_cli/resources/one-liner-template.js
                wilton_${WILTON_VERSION}/conf/one-liner-template.js
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/js/examples/winservice/config.json
                wilton_${WILTON_VERSION}/conf/config.json
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/resources/toolchains/${STATICLIB_TOOLCHAIN}-${WILTON_BUILD_FLAVOUR}.cmake
                wilton_${WILTON_VERSION}/devel/${STATICLIB_TOOLCHAIN}.cmake
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/resources/installer/.keep
                wilton_${WILTON_VERSION}/log/.keep
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/resources/installer/.keep
                wilton_${WILTON_VERSION}/work/.keep
        COMMAND ${CMAKE_COMMAND} -E copy
                wilton.version
                wilton_${WILTON_VERSION}/conf/wilton.version  
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating distribution at [${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}] ..." )

add_dependencies ( dist
        wilton_core
        wilton_db
        wilton_duktape
        wilton_channel
        wilton_cli
        wilton_cron
        wilton_fs
        wilton_http
        wilton_loader
        wilton_logging
        wilton_net
        wilton_pdf
        wilton_process
        wilton_rhino
        wilton_signal
        wilton_thread
        stdlib )

if ( STATICLIB_TOOLCHAIN MATCHES "windows_[^_]+_[^_]+" )
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
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
    add_dependencies ( dist_windows wilton_winservice )      
    add_dependencies ( dist dist_windows )

    configure_file ( 
            ${CMAKE_CURRENT_LIST_DIR}/resources/installer/installer.json
            ${CMAKE_CURRENT_BINARY_DIR}/installer.json )

    add_custom_target ( installer
            COMMAND ${CMAKE_COMMAND} -E remove wilton_${WILTON_VERSION}.wxs
            COMMAND ${TOOLS_JAVA}
                    -XX:+UseSerialGC -XX:+TieredCompilation -XX:TieredStopAtLevel=1
                    -jar ${CMAKE_CURRENT_LIST_DIR}/tools/windows/wixgen/wixgen.jar
                    wilton_${WILTON_VERSION}
                    -c installer.json
                    -o wilton_${WILTON_VERSION}.wxs
            COMMAND ${CMAKE_CURRENT_LIST_DIR}/tools/windows/wix/bin/candle -v -nologo wilton_${WILTON_VERSION}.wxs
            COMMAND ${CMAKE_CURRENT_LIST_DIR}/tools/windows/wix/bin/light
                    -v -nologo -sw1076 -sval -ext WixUIExtension -ext WixUtilExtension
                    wilton_${WILTON_VERSION}.wixobj
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Creating MSI at [${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}.msi] ..." )
    add_dependencies ( installer dist )
else ( )
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
                    ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_serial/include/wilton/wilton_serial.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_serial.h
            # usb
            COMMAND ${CMAKE_COMMAND} -E copy
                    bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
                    wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_usb${CMAKE_SHARED_LIBRARY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
                    ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_usb/include/wilton/wilton_usb.h
                    wilton_${WILTON_VERSION}/devel/include/wilton/wilton_usb.h
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )
    add_dependencies ( dist_linux wilton_jsc wilton_serial wilton_usb )      
    add_dependencies ( dist dist_linux )
endif ( )

add_custom_target ( test
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/js/wilton/test/index.js -m ${CMAKE_CURRENT_LIST_DIR}/js
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/js/wilton/test/index.js -m ${CMAKE_CURRENT_LIST_DIR}/js -j duktape
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runNodeTests.js -m ${CMAKE_CURRENT_LIST_DIR}/js
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runNodeTests.js -m ${CMAKE_CURRENT_LIST_DIR}/js -j duktape
        COMMAND cd ${CMAKE_CURRENT_LIST_DIR}/jni && ${CMAKE_CURRENT_LIST_DIR}/tools/maven/bin/mvn clean test
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
        COMMENT "Running tests ..." )
add_dependencies ( test dist )

if ( STATICLIB_TOOLCHAIN MATCHES "linux_[^_]+_[^_]+" )
    set ( ${PROJECT_NAME}_VGOPTS 
            --leak-check=yes --show-reachable=yes --track-origins=yes --error-exitcode=42 --track-fds=yes
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/deps/cmake/resources/valgrind/openssl_malloc.supp
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/deps/cmake/resources/valgrind/popt_poptGetNextOpt.supp 
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/resources/valgrind/wilton_dyload.supp 
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/resources/valgrind/wilton_http.supp
        CACHE INTERNAL "" )

    add_custom_target ( valgrind
            COMMAND valgrind ${${PROJECT_NAME}_VGOPTS}
                    ./bin/wilton ./examples/binaryModule.js -b ./examples/binmod.wlib -j duktape
            COMMAND valgrind ${${PROJECT_NAME}_VGOPTS}
                    ./bin/wilton ${CMAKE_CURRENT_LIST_DIR}/js/wilton/test/index.js -m ../../js -j duktape
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            COMMENT "Running valgrind ..." )
    add_dependencies ( valgrind dist )
endif ( )
        
add_custom_target ( docs
        COMMAND ${CMAKE_COMMAND} -E remove_directory doxy
        COMMAND ${CMAKE_COMMAND} -E remove_directory docs
        COMMAND ${CMAKE_COMMAND} -E make_directory docs
        COMMAND ${TOOLS_JJS}
                -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                ${CMAKE_CURRENT_LIST_DIR}/resources/doxygen/generate-doxy.js
                ${CMAKE_CURRENT_LIST_DIR}/js/wilton doxy
        COMMAND doxygen
        # poor man's WARN_AS_ERROR
        COMMAND [ ! -s doxygen_warnings.txt ]
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating documentation at [${CMAKE_CURRENT_BINARY_DIR}/docs] ..." )
# todo

# maven install
#if ( WILTON_TOOLCHAIN MATCHES "android_armeabi_[^_]+" )
#    set ( ${PROJECT_NAME}_CLASSIFIER "android_armeabi" CACHE INTERNAL "" )
#    set ( ${PROJECT_NAME}_JAR_LIB_DIR "armeabi" CACHE INTERNAL "" )
#elseif ( WILTON_TOOLCHAIN MATCHES "android_i386_[^_]+" )
#    set ( ${PROJECT_NAME}_CLASSIFIER "android_i386" CACHE INTERNAL "" )
#    set ( ${PROJECT_NAME}_JAR_LIB_DIR "x86" CACHE INTERNAL "" )
#elseif ( WILTON_TOOLCHAIN MATCHES "linux_amd64_[^_]+" )
#    set ( ${PROJECT_NAME}_CLASSIFIER "linux_amd64" CACHE INTERNAL "" )
#elseif ( WILTON_TOOLCHAIN MATCHES "windows_amd64_[^_]+" )
#    set ( ${PROJECT_NAME}_CLASSIFIER "windows_amd64" CACHE INTERNAL "" )
#elseif ( WILTON_TOOLCHAIN MATCHES "windows_i386_[^_]+" )
#    set ( ${PROJECT_NAME}_CLASSIFIER "windows_i386" CACHE INTERNAL "" )
#else ( )
#    message ( FATAL_ERROR "Unsupported toolchain: [WILTON_TOOLCHAIN]" )
#endif ( )
#string ( SUBSTRING ${CMAKE_SHARED_LIBRARY_SUFFIX} 1 -1 ${PROJECT_NAME}_SHARED_SUFFIX )
#string ( SUBSTRING ${CMAKE_STATIC_LIBRARY_SUFFIX} 1 -1 ${PROJECT_NAME}_STATIC_SUFFIX )

#add_custom_target ( mvninstall_shared
#        COMMAND mvn install:install-file
#                -Dfile=${CMAKE_SHARED_LIBRARY_PREFIX}${PROJECT_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}
#                -DgroupId=net.wiltontoolkit
#                -DartifactId=${PROJECT_NAME}
#                -Dversion=${${PROJECT_NAME}_STATICLIB_VERSION}
#                -Dclassifier=${${PROJECT_NAME}_CLASSIFIER}
#                -Dpackaging=${${PROJECT_NAME}_SHARED_SUFFIX}
#        WORKING_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}        
#        COMMENT "Installing shared library into local Maven repository ..." )
#
#add_custom_target ( mvninstall_import
#        COMMAND mvn install:install-file
#                -Dfile=${CMAKE_SHARED_LIBRARY_PREFIX}${PROJECT_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}
#                -DgroupId=net.wiltontoolkit
#                -DartifactId=${PROJECT_NAME}
#                -Dversion=${${PROJECT_NAME}_STATICLIB_VERSION}
#                -Dclassifier=${${PROJECT_NAME}_CLASSIFIER}
#                -Dpackaging=${${PROJECT_NAME}_STATIC_SUFFIX}
#        WORKING_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}        
#        COMMENT "Installing import library into local Maven repository ..." )

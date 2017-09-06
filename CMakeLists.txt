
cmake_minimum_required ( VERSION 2.8.12 )

# versioning
string ( TIMESTAMP WILTON_VERSION_YEAR "%Y" )
string ( TIMESTAMP WILTON_VERSION_YEAR_SHORT "%y" )
string ( TIMESTAMP WILTON_VERSION_MONTH "%m" )
string ( TIMESTAMP WILTON_VERSION_DAY "%d" )
set ( WILTON_VERSION_BUILD "0" )
set ( WILTON_VERSION ${WILTON_VERSION_YEAR}${WILTON_VERSION_MONTH}${WILTON_VERSION_DAY}${WILTON_VERSION_BUILD}  CACHE STRING "" )
set ( WILTON_VERSION_WIN ${WILTON_VERSION_YEAR_SHORT}.${WILTON_VERSION_MONTH}.${WILTON_VERSION_DAY}.${WILTON_VERSION_BUILD} CACHE STRING "" )
set ( WILTON_VERSION_EXE ${WILTON_VERSION_YEAR_SHORT},${WILTON_VERSION_MONTH},${WILTON_VERSION_DAY},${WILTON_VERSION_BUILD} CACHE STRING "" )

# toolchain setup
if ( NOT DEFINED STATICLIB_TOOLCHAIN )
    if ( WIN32 )
        if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
            set ( STATICLIB_TOOLCHAIN "windows_amd64_msvc" CACHE STRING "" )
        else ( )
            set ( STATICLIB_TOOLCHAIN "windows_i386_msvc" CACHE STRING "" )
        endif ( )
    elseif ( APPLE )
        set ( STATICLIB_TOOLCHAIN "macosx_amd64_clang" CACHE STRING "" )
    elseif ( UNIX )
        set ( STATICLIB_TOOLCHAIN "linux_amd64_gcc" CACHE STRING "" )
    else ( )
        message ( FATAL_ERROR "Cannot find out toolchain to use, please specify [STATICLIB_TOOLCHAIN]" )
    endif ( )
endif ( )
set ( STATICLIB_DEPS ${CMAKE_CURRENT_LIST_DIR}/deps CACHE INTERNAL "" )    
set ( STATICLIB_CMAKE ${STATICLIB_DEPS}/cmake CACHE INTERNAL "" )    
set ( CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/resources/toolchains/${STATICLIB_TOOLCHAIN}.cmake CACHE INTERNAL "" )

# master project
project ( wilton CXX C )
include ( ${STATICLIB_CMAKE}/staticlibs_common.cmake )

# core
add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/core )

# modules
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_cli )
if ( ${CMAKE_SYSTEM_NAME} STREQUAL "Windows" )
    staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_winservice )
else ( )
    add_custom_target ( wilton_winservice )
endif ( )
staticlib_add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_db )

# platform tools
set ( TOOLS_JAVA java )
set ( TOOLS_JJS jjs )
set ( TOOLS_ZIP zip )
if ( ${CMAKE_SYSTEM_NAME} STREQUAL "Windows" )
    set ( TOOLS_JAVA ${CMAKE_CURRENT_LIST_DIR}/tools/windows/jdk8/bin/java.exe )
    set ( TOOLS_JJS ${CMAKE_CURRENT_LIST_DIR}/tools/windows/jdk8/bin/jjs.exe )
    set ( TOOLS_ZIP ${CMAKE_CURRENT_LIST_DIR}/tools/windows/zip/zip.exe )
endif ( )

add_custom_command ( OUTPUT js.zip
        COMMAND ${CMAKE_COMMAND} -E remove_directory js
        COMMAND ${TOOLS_JJS}
                -J-XX:+UseSerialGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1
                -cp ${CMAKE_CURRENT_LIST_DIR}/tools/closure-compiler/closure-compiler.jar
                ${CMAKE_CURRENT_LIST_DIR}/tools/convertion-scripts/minify-modules.js
                -- ${CMAKE_CURRENT_LIST_DIR}/js js
        COMMAND cd js && ${TOOLS_ZIP} -qr9 js.zip *
        COMMAND ${CMAKE_COMMAND} -E rename js/js.zip js.zip
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Preparing JavaScript modules bundle ..." )

add_custom_target( js DEPENDS js.zip )

add_custom_target ( dist
        COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
        COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
        COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/conf
        COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/devel
        COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/log
        COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/work
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_core${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
                wilton_${WILTON_VERSION}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}wilton_db${CMAKE_SHARED_LIBRARY_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                bin/wilton_cli${CMAKE_EXECUTABLE_SUFFIX}
                wilton_${WILTON_VERSION}/bin/wilton${CMAKE_EXECUTABLE_SUFFIX}
        COMMAND ${CMAKE_COMMAND} -E copy
                js.zip
                wilton_${WILTON_VERSION}/js.zip
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${CMAKE_CURRENT_LIST_DIR}/js/examples
                wilton_${WILTON_VERSION}/examples
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/modules/wilton_cli/resources/one-liner-template.js
                wilton_${WILTON_VERSION}/conf/one-liner-template.js
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/js/examples/winservice/config.json
                wilton_${WILTON_VERSION}/conf/config.json
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                ${CMAKE_CURRENT_LIST_DIR}/core/include
                wilton_${WILTON_VERSION}/devel/include
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/resources/toolchains/${STATICLIB_TOOLCHAIN}.cmake
                wilton_${WILTON_VERSION}/devel/${STATICLIB_TOOLCHAIN}.cmake
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/resources/installer/.keep
                wilton_${WILTON_VERSION}/log/.keep
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_LIST_DIR}/resources/installer/.keep
                wilton_${WILTON_VERSION}/work/.keep
        COMMAND ${CMAKE_COMMAND} -E copy
                core/wilton.version
                wilton_${WILTON_VERSION}/wilton.version  
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Creating distribution at [${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION}] ..." )

add_dependencies ( dist wilton_core wilton_cli wilton_db js )

if ( ${CMAKE_SYSTEM_NAME} STREQUAL "Windows" )
    add_custom_target ( dist_windows
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}
            COMMAND ${CMAKE_COMMAND} -E make_directory wilton_${WILTON_VERSION}/bin
            COMMAND ${CMAKE_COMMAND} -E copy
                bin/wilton_winservice.exe
                wilton_${WILTON_VERSION}/bin/wilton_winservice.exe
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
endif ( )

add_custom_target ( test
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runWiltonTests.js -m ${CMAKE_CURRENT_LIST_DIR}/js
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runSanityTests.js
        COMMAND bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runNodeTests.js -m ${CMAKE_CURRENT_LIST_DIR}/js
        COMMAND cd ${CMAKE_CURRENT_LIST_DIR}/jni && ${CMAKE_CURRENT_LIST_DIR}/tools/maven/bin/mvn clean test
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
        COMMENT "Running tests ..." )
add_dependencies ( test dist )

if ( NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Windows" )
    set ( ${PROJECT_NAME}_VGOPTS 
            --leak-check=yes --show-reachable=yes --track-origins=yes --error-exitcode=42 --track-fds=yes
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/deps/cmake/resources/valgrind/openssl_malloc.supp
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/deps/cmake/resources/valgrind/popt_poptGetNextOpt.supp 
            --suppressions=${CMAKE_CURRENT_LIST_DIR}/deps/cmake/resources/valgrind/wilton_dyload.supp 
        CACHE INTERNAL "" )
    add_custom_target ( valgrind
            COMMAND valgrind ${${PROJECT_NAME}_VGOPTS}
                    ./bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runZipLoadTests.js
            COMMAND valgrind ${${PROJECT_NAME}_VGOPTS}
                    ./bin/wilton ${CMAKE_CURRENT_LIST_DIR}/core/test/scripts/runWiltonTests.js -m ../../js
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/wilton_${WILTON_VERSION} 
            COMMENT "Running valgrind ..." )
    add_dependencies ( valgrind dist )
endif ( )
        
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

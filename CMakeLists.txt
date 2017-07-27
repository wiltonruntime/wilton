
cmake_minimum_required ( VERSION 2.8.12 )

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
project ( wilton_master CXX C )
include ( ${STATICLIB_CMAKE}/staticlibs_common.cmake )

# add core
add_subdirectory ( ${CMAKE_CURRENT_LIST_DIR}/core )


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

Wilton [work in progress]
=========================

[![travis](https://travis-ci.org/wilton-iot/wilton.svg?branch=master)](https://travis-ci.org/wilton-iot/wilton)
[![appveyor](https://ci.appveyor.com/api/projects/status/github/wilton-iot/wilton?svg=true)](https://ci.appveyor.com/project/wilton-iot/wilton)

TODO: description

Link to the [JavaScript API documentation](https://wilton-iot.github.io/wilton/docs/html/namespaces.html).

How to build
------------

_Note: see [releases](https://github.com/wilton-iot/wilton/releases) for Windows binaries (MSI installer)_

_Note: see [repo](https://copr.fedorainfracloud.org/coprs/wilton/wilton/) for CentOS 7 and Fedora binaries (RPM packages)_

Obtain sources and build tools:

    git clone https://github.com/wilton-iot/wilton.git
    cd wilton
    git submodule update --init

See platform-specific instructions below.

### Android

Run on Linux `x86_64`:

    cd wilton
    . resources/scripts/env-linux.sh
    mkdir build
    cd build
    cmake .. -DSTATICLIB_TOOLCHAIN=android_armeabi_gcc -DANDROID_SDK_ENABLE_LIBC_PRELOAD=OFF
    make android_apk

Resulting APK can be tested in VirtualBox using [Android x86](http://www.android-x86.org/) image with [native bridge](https://stackoverflow.com/a/13005569/314015) enabled.

### Windows

Install dependencies:

 - [Visual Studio 2013 Update 5 Express for Windows Desktop](https://www.visualstudio.com/en-us/news/releasenotes/vs2013-update5-vs)
([direct ISO link](https://go.microsoft.com/fwlink/?LinkId=532499&type=ISO))
 - [Windows Driver Kit Version 7.1.0](https://www.microsoft.com/en-us/download/details.aspx?id=11800)
 - [CMake](https://cmake.org/download/)
 - [OpenJDK 8](https://github.com/ojdkbuild/ojdkbuild#downloads-for-windows-x86_64).

Prepare environment:

    cd wilton
    resources\scripts\windows-tools.bat
    mkdir build
    cd build
    
Build for `x86_64`:

    cmake .. -G "Visual Studio 12 2013 Win64"
    cmake --build . --config Release --target installer
    
Build for `x86` (compatible with Windows XP):

    cmake .. -G "Visual Studio 12 2013" -T v120_xp
    cmake --build . --config Release --target installer

### Fedora 27+

Install dependencies:

    sudo dnf install gcc-c++ make cmake pkg-config zip java-1.8.0-openjdk-devel zlib-devel jansson-devel log4cplus-devel openssl-devel curl-devel asio-devel popt-devel sqlite-devel postgresql-devel soci-devel soci-sqlite3-devel soci-postgresql-devel libpng-devel libharu-devel systemd-devel libusbx-devel webkitgtk4-jsc-devel glib2-devel gtk3-devel webkitgtk4-devel

Build:

    cd wilton
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=fedora
    make dist

### Ubuntu 16.04 (also works for Debian Stretch)

Install dependencies:

    sudo apt install build-essential cmake pkg-config zip openjdk-8-jdk zlib1g-dev libjansson-dev liblog4cplus-dev libssl-dev libcurl4-openssl-dev libasio-dev libpopt-dev libsqlite3-dev libpq-dev libsoci-dev libpng-dev libusb-1.0-0-dev libudev-dev libglib2.0-dev libjavascriptcoregtk-4.0-dev libgtk-3-dev libwebkit2gtk-4.0-dev

Build:

    cd wilton
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=xenial
    make dist

To build for ARMv7 (`armhf`) 32-bit arch use the following `cmake` args:

    cmake .. -DWILTON_BUILD_FLAVOUR=xenial -DSTATICLIB_TOOLCHAIN=linux_armhf_gcc 

To build for ARMv8 (`aarch64`) 64-bit arch use the following `cmake` args:

    cmake .. -DWILTON_BUILD_FLAVOUR=xenial -DSTATICLIB_TOOLCHAIN=linux_aarch64_gcc 

### Ubuntu 18.04

Install dependencies:

    sudo apt install build-essential cmake pkg-config zip openjdk-8-jdk zlib1g-dev libjansson-dev liblog4cplus-dev libssl-dev libcurl4-openssl-dev libasio-dev libpopt-dev libsqlite3-dev libpq-dev libsoci-dev libpng-dev libhpdf-dev libusb-1.0-0-dev libudev-dev libglib2.0-dev libjavascriptcoregtk-4.0-dev libgtk-3-dev libwebkit2gtk-4.0-dev

Build:

    cd wilton
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=bionic
    make dist

### CentOS 7

Enable [EPEL repository](https://fedoraproject.org/wiki/EPEL):

    sudo yum install epel-release

Install dependencies:

    sudo yum install gcc-c++ make cmake pkgconfig zip java-1.8.0-openjdk-devel zlib-devel jansson-devel log4cplus-devel openssl-devel asio-devel popt-devel sqlite-devel postgresql-devel soci-devel soci-sqlite3-devel soci-postgresql-devel libpng-devel systemd-devel libusbx-devel webkitgtk4-jsc-devel glib2-devel gtk3-devel webkitgtk4-devel

Build:

    cd wilton
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=el7
    make dist

### Debian Wheezy (also works for Ubuntu 14.04)

Install dependencies:

    sudo apt-get install build-essential pkg-config zip zlib1g-dev libjansson-dev liblog4cplus-dev libssl-dev libcurl4-openssl-dev libpopt-dev libsqlite3-dev libpq-dev libpng12-dev libusb-1.0-0-dev libudev-dev libglib2.0-dev libjavascriptcoregtk-3.0-dev libgtk-3-dev libwebkitgtk-3.0-dev

Build:

    cd wilton
    . resources/scripts/env-linux.sh
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=wheezy
    make dist

### Mac OS X

Install Xcode, Xcode Command Line Tools and Java 8.

Install build tools and dependencies:

    brew install cmake pkg-config

Setup environment:

    export JAVA_HOME=path/to/jdk
    export PATH=$PATH:$JAVA_HOME/bin

Build:

    cd wilton
    mkdir build
    cd build
    cmake ..
    make dist

License information
-------------------

This project is released under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Changelog
---------

**2018-09-06**

 * `v201809061`
 * dedicated PostgreSQL connection API
 * sqlite crash fix and other DB fixes
 * Debian Stretch AArch64 support

**2018-07-19**

 * `v201807191`
 * serviceability JS API
 * USB connect fix on Windows
 * Ubuntu 18.04 support

**2018-06-24**

 * `v201806241`
 * WebSocket fix for Firefox
 * Windows CI releases setup

**2018-06-20**

 * `v201806201`
 * support for `v8`, `chakracore` and `mozjs` engines (only on Linux-x86_64)
 * WebSocket suport in `wilton/Server`
 * `witon/kiosk` desktop WebViews
 * Linux ARMv7 support
 * a number of JS modules added

**2018-04-08**

 * `v201804081`
 * support for `rhino` and `nashorn` engines in CLI launcher
 * support for pure-JS OpenJFX apps with Rhino engine

**2018-03-25**

 * `v201803251`
 * `Serial` and `USB` support on Windows
 * Fedora 28 builds
 * support for native modules in Rust and Haskell

**2018-03-11**

 * `v201803111`
 * CentOS 7 CI setup
 * debugging with Duktape engine from VSCode
 * native debuginfo bundles for all platforms
 * Chakra JS engine support on windows-x86_64
 * TCP and UDP sockets access from JS
 * native deps update
 * do not require Brew OpenSSL on Mac
 * `xml-js`, `uglify-js` and `es6-shim` JS libs

**2018-01-27**

 * `v201801271`
 * Jansson 2.10 usage fix on CentOS 7

**2018-01-25**

 * `v201801251`
 * more baud rate values for `wilton/Serial`
 * fix spawned process signals on Linux in `wilton/process`
 * update JSC to `webkitgtk-4.0` in CentOS 7

**2018-01-09**

 * `v201801091`
 * PNG images support in `wilton/PDFDocument`

**2017-12-05**

 * `v201712051`
 * `wilton/zip` implementation for ZIP files IO
 * some more JS modules added
 * all JS modules (except `bluebird` and `wilton/*` ) adapted for use in browser
 * `examples/browser` web-app example added

**2017-11-27**

 * `v201711271`
 * binary data (`hex` flag) support in `wilton/fs`
 * use `copyfile` syscall on MacOS for `wilton/fs.copyFile()`
 * about 20 new JS modules adapted from NPM

**2017-11-22**

 * `v201711221`
 * `filesize` JS module added
 * `appname` support in CLI launcher

**2017-11-15**

 * `v201711151`
 * shutdown fix on MacOS 
 * shutdown fix on Windows with JVM engines

**2017-11-07**

 * `v201711071`
 * Android, MacOS and Win64 builds

**2017-10-29**

 * `v201710291`
 * JavaScriptCore engine
 * logging added

**2017-10-21**

 * `v201710221`
 * move all possible logic from core to modules

**2017-10-13**
 
 * `v201710161`
 * better channel api
 * db logging
 * bootstrap example

**2017-10-13**

 * `v201710131`
 * usb and serial fixes
 * fs, logger and hex enhancements


**2017-10-08**

 * build support for Ubuntu 16.04, Fedora 27 and CentOS 7
 * readme added

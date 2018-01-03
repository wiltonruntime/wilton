Wilton [work in progress]
=========================

[![travis](https://travis-ci.org/wilton-iot/wilton.svg?branch=master)](https://travis-ci.org/wilton-iot/wilton)
[![appveyor](https://ci.appveyor.com/api/projects/status/github/wilton-iot/wilton?svg=true)](https://ci.appveyor.com/project/wilton-iot/wilton)

TODO: description

Link to the [JavaScript API documentation](https://wilton-iot.github.io/wilton/docs/html/namespaces.html).

How to build
------------

_Note: see [releases](https://github.com/wilton-iot/wilton/releases) for Windows binaries (MSI installer)_

Obtain sources and build tools:

    git clone --recursive https://github.com/wilton-iot/wilton.git

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

32-bit build environment:

    cd wilton
    resources\scripts\set-compile-env-vs12-sdk71a-x86.bat

64-bit build environment:

    cd wilton
    resources\scripts\set-compile-env-vs12-sdk81-x86_64.bat

Build:

    mkdir build
    cd build
    cmake ..
    nmake installer

### Fedora 27+

Install dependencies:

    sudo dnf install gcc-c++ make pkg-config zip zlib-devel jansson-devel log4cplus-devel openssl-devel curl-devel asio-devel popt-devel sqlite-devel postgresql-devel soci-devel soci-sqlite3-devel soci-postgresql-devel libharu-devel systemd-devel libusbx-devel webkitgtk4-jsc-devel

Build:

    cd wilton
    . resources/scripts/env-linux.sh
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=fedora
    make dist

### Ubuntu 16.04

Install dependencies:

    sudo apt install build-essential pkg-config zip zlib1g-dev libjansson-dev liblog4cplus-dev libssl-dev libcurl4-openssl-dev libasio-dev libpopt-dev libsqlite3-dev libpq-dev libsoci-dev libpng12-dev libusb-1.0-0-dev libudev-dev libglib2.0-dev libjavascriptcoregtk-4.0-dev

Build:

    cd wilton
    . resources/scripts/env-linux.sh
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=xenial
    make dist

### CentOS 7

Enable [EPEL repository](https://fedoraproject.org/wiki/EPEL):

    sudo yum install epel-release

Install dependencies:

    sudo yum install gcc-c++ make pkgconfig zip zlib-devel jansson-devel log4cplus-devel openssl-devel asio-devel popt-devel sqlite-devel postgresql-devel soci-devel soci-sqlite3-devel soci-postgresql-devel libpng-devel systemd-devel libusbx-devel webkitgtk3-devel

Build:

    cd wilton
    . resources/scripts/env-linux.sh
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=el7
    make dist

### Debian Wheezy (also works for Ubuntu 14.04)

Install dependencies:

    sudo apt-get install build-essential pkg-config zip zlib1g-dev libjansson-dev liblog4cplus-dev libssl-dev libcurl4-openssl-dev libpopt-dev libsqlite3-dev libpq-dev libpng12-dev libusb-1.0-0-dev libudev-dev libglib2.0-dev libjavascriptcoregtk-3.0-dev

Build:

    cd wilton
    . resources/scripts/env-linux.sh
    mkdir build
    cd build
    cmake .. -DWILTON_BUILD_FLAVOUR=wheezy
    make dist

### Mac OS X

Install Xcode, Xcode Command Line Tools and Java (required for dist bundling).

Install build tools and dependencies:

    brew install cmake pkg-config openssl

Setup environment (adjust OpenSSL version as needed):

    export JAVA_HOME=path/to/jdk
    export PATH=$PATH:$JAVA_HOME/bin
    export PKG_CONFIG_PATH=/usr/local/Cellar/openssl/1.0.2m/lib/pkgconfig/:$PKG_CONFIG_PATH

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

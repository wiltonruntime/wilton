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

# COPR spec file
# https://copr.fedorainfracloud.org/coprs/wilton/wilton/

Name:           wilton
Version:        master
Release:        1%{?dist}
Summary:        JavaScript runtime
Group:          Development/Languages
License:        ASL 2.0
URL:            https://github.com/wiltonruntime/wilton

BuildRequires:  gcc
BuildRequires:  gcc-c++

BuildRequires:  git
BuildRequires:  make
BuildRequires:  cmake
BuildRequires:  pkgconfig
BuildRequires:  zip
BuildRequires:  java-1.8.0-openjdk-devel

BuildRequires:  zlib-devel
BuildRequires:  jansson-devel
BuildRequires:  log4cplus-devel
BuildRequires:  openssl-devel
BuildRequires:  asio-devel
BuildRequires:  popt-devel
BuildRequires:  sqlite-devel
BuildRequires:  postgresql-devel
BuildRequires:  soci-devel
BuildRequires:  soci-sqlite3-devel
BuildRequires:  soci-postgresql-devel
BuildRequires:  libjpeg-turbo-devel
BuildRequires:  libpng-devel
BuildRequires:  systemd-devel
BuildRequires:  webkitgtk4-jsc-devel
BuildRequires:  libgit2-devel
BuildRequires:  systemd-devel
BuildRequires:  curl-devel
BuildRequires:  libharu-devel
BuildRequires:  glib2-devel
BuildRequires:  gtk3-devel
BuildRequires:  webkitgtk4-devel

%description
Multi-threaded JavaScript runtime environment with batteries included

%package devel
Summary:        Development files
Requires: 	wilton
%description devel
Wilton development files

%package jsc
Summary:        JavaScriptCore JIT engine
Requires: 	wilton
%description jsc
JavaScriptCore JIT engine for Wilton runtime

%package webview
Summary:        WebView based on WebKitGTK
Requires: 	wilton
%description webview
WebView based on WebKitGTK for Wilton runtime

%prep
git clone --branch %{version} https://github.com/wiltonruntime/wilton.git
cd wilton
# core
git submodule update --init core
# deps
git submodule update --init deps/cmake
git submodule update --init deps/external_duktape
git submodule update --init deps/external_quickjs
git submodule update --init deps/external_utf8cpp
git submodule update --init deps/lookaside_utf8cpp
git submodule update --init deps/staticlib_compress
git submodule update --init deps/staticlib_concurrent
git submodule update --init deps/staticlib_config
git submodule update --init deps/staticlib_cron
git submodule update --init deps/ccronexpr
git submodule update --init deps/staticlib_crypto
git submodule update --init deps/staticlib_endian
git submodule update --init deps/staticlib_http
git submodule update --init deps/staticlib_io
git submodule update --init deps/staticlib_jni
git submodule update --init deps/staticlib_json
git submodule update --init deps/staticlib_mustache
git submodule update --init deps/mstch_cpp11
git submodule update --init deps/staticlib_orm
git submodule update --init deps/staticlib_pimpl
git submodule update --init deps/staticlib_pion
git submodule update --init deps/staticlib_ranges
git submodule update --init deps/staticlib_support
git submodule update --init deps/staticlib_tinydir
git submodule update --init deps/tinydir
git submodule update --init deps/staticlib_unzip
git submodule update --init deps/staticlib_utils
git submodule update --init deps/staticlib_websocket
# js
rm -rf js
git clone --branch %{version} https://github.com/wiltonruntime/js-libs-ci-monorepo.git js
# jni
git submodule update --init jni
# engines
git submodule update --init engines/wilton_duktape
git submodule update --init engines/wilton_jsc
git submodule update --init engines/wilton_quickjs
git submodule update --init engines/wilton_rhino
# modules
git submodule update --init modules/wilton_channel
git submodule update --init modules/wilton_cli
git submodule update --init modules/wilton_cron
git submodule update --init modules/wilton_crypto
git submodule update --init modules/wilton_db
git submodule update --init modules/wilton_fs
git submodule update --init modules/wilton_ghc
git submodule update --init modules/wilton_git
git submodule update --init modules/wilton_http
git submodule update --init modules/wilton_kiosk
git submodule update --init modules/wilton_kvstore
git submodule update --init modules/wilton_loader
git submodule update --init modules/wilton_logging
git submodule update --init modules/wilton_mustache
git submodule update --init modules/wilton_net
git submodule update --init modules/wilton_pdf
git submodule update --init modules/wilton_process
git submodule update --init modules/wilton_serial
git submodule update --init modules/wilton_server
git submodule update --init modules/wilton_service
git submodule update --init modules/wilton_signal
git submodule update --init modules/wilton_systemd
git submodule update --init modules/wilton_thread
git submodule update --init modules/wilton_zip
# tools
git submodule update --init tools/maven
git submodule update --init tools/mvnrepo

%build
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
cd wilton
mkdir build
cd build
cmake .. -DWILTON_BUILD_FLAVOUR=fedora -DWILTON_RELEASE=%{version}
make -j 4
make dist_unversioned

%check
cd wilton
cd build
cat <<EOF >> openssl.conf
openssl_conf = openssl_init
[openssl_init]
ssl_conf = ssl_sect
[ssl_sect]
system_default = system_default_sect
[system_default_sect]
CipherString = DEFAULT@SECLEVEL=1
EOF
export OPENSSL_CONF=`pwd`/openssl.conf
make test_js

%install
mkdir -p %{buildroot}/opt/wilton
cp -a wilton/build/wilton_dist/* %{buildroot}/opt/wilton/
mkdir -p %{buildroot}/usr/bin
ln -s /opt/wilton/bin/wilton %{buildroot}/usr/bin/wilton

%files
/opt/wilton/bin/libwilton_channel.so
/opt/wilton/bin/libwilton_core.so
/opt/wilton/bin/libwilton_cron.so
/opt/wilton/bin/libwilton_crypto.so
/opt/wilton/bin/libwilton_db.so
/opt/wilton/bin/libwilton_duktape.so
/opt/wilton/bin/libwilton_fs.so
/opt/wilton/bin/libwilton_ghc.so
/opt/wilton/bin/libwilton_git.so
/opt/wilton/bin/libwilton_http.so
/opt/wilton/bin/libwilton_kvstore.so
/opt/wilton/bin/libwilton_loader.so
/opt/wilton/bin/libwilton_logging.so
/opt/wilton/bin/libwilton_mustache.so
/opt/wilton/bin/libwilton_net.so
/opt/wilton/bin/libwilton_pdf.so
/opt/wilton/bin/libwilton_process.so
/opt/wilton/bin/libwilton_quickjs.so
/opt/wilton/bin/libwilton_rhino.so
/opt/wilton/bin/libwilton_serial.so
/opt/wilton/bin/libwilton_server.so
/opt/wilton/bin/libwilton_service.so
/opt/wilton/bin/libwilton_signal.so
/opt/wilton/bin/libwilton_systemd.so
/opt/wilton/bin/libwilton_thread.so
/opt/wilton/bin/libwilton_zip.so
/opt/wilton/bin/wilton_rhino.jar
/opt/wilton/bin/wilton
/opt/wilton/lib/*
/opt/wilton/std.wlib
/usr/bin/wilton

%files devel
/opt/wilton/devel/*
/opt/wilton/examples/*

%files jsc
/opt/wilton/bin/libwilton_jsc.so

%files webview
/opt/wilton/bin/libwilton_kiosk.so

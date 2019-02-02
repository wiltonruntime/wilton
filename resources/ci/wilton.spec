# Copyright 2018, alex at staticlibs.net
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

# Fedora COPR spec file
# https://copr.fedorainfracloud.org/coprs/wilton/wilton/

%if ! 0%{?epel}
%global wilton_build_flavour fedora
%else
%global wilton_build_flavour el7
%endif
%global debug_package %{nil}

Name:           wilton
Version:        v201902021
Release:        1%{?dist}
Summary:        JavaScript runtime
Group:          Development/Languages
License:        ASL 2.0
URL:            https://github.com/wilton-iot/wilton

BuildRequires:  gcc
BuildRequires:  gcc-c++

BuildRequires:  git
BuildRequires:  make
BuildRequires:  cmake
BuildRequires:  pkgconfig
BuildRequires:  zip
BuildRequires:  java-1.8.0-openjdk-devel
BuildRequires:  valgrind

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
BuildRequires:  libpng-devel
BuildRequires:  systemd-devel
BuildRequires:  libusbx-devel
BuildRequires:  webkitgtk4-jsc-devel
# kiosk
BuildRequires:  glib2-devel
BuildRequires:  gtk3-devel
BuildRequires:  webkitgtk4-devel

%if ! 0%{?epel}
BuildRequires:  curl-devel
BuildRequires:  libharu-devel
%endif

%description
Multi-threaded JavaScript runtime environment with batteries included

%prep
git clone --branch %{version} https://github.com/wilton-iot/wilton.git
cd wilton
# core
git submodule update --init core
# deps
git submodule update --init deps/cmake
git submodule update --init deps/external_curl
git submodule update --init deps/lookaside_curl
git submodule update --init deps/external_chakracore
git submodule update --init deps/external_duktape
git submodule update --init deps/external_hpdf
git submodule update --init deps/external_icu
git submodule update --init deps/lookaside_libharu
git submodule update --init deps/external_mozjs
git submodule update --init deps/external_v8
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
git clone --branch %{version} https://github.com/wilton-iot/js-libs-ci-monorepo.git js
# jni
git submodule update --init jni
# engines
git submodule update --init engines/wilton_chakracore
git submodule update --init engines/wilton_duktape
git submodule update --init engines/wilton_jsc
git submodule update --init engines/wilton_mozjs
git submodule update --init engines/wilton_rhino
git submodule update --init engines/wilton_v8
# modules
git submodule update --init modules/wilton_channel
git submodule update --init modules/wilton_cli
git submodule update --init modules/wilton_cron
git submodule update --init modules/wilton_crypto
git submodule update --init modules/wilton_db
git submodule update --init modules/wilton_fs
git submodule update --init modules/wilton_ghc
git submodule update --init modules/wilton_http
git submodule update --init modules/wilton_kiosk
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
git submodule update --init modules/wilton_thread
git submodule update --init modules/wilton_usb
git submodule update --init modules/wilton_zip
# tools
git submodule update --init tools/closure-compiler
git submodule update --init tools/convertion-scripts
git submodule update --init tools/maven
git submodule update --init tools/mvnrepo

%build
cd wilton
mkdir build
cd build
cmake .. -DWILTON_BUILD_FLAVOUR=%{wilton_build_flavour} -DWILTON_RELEASE=%{version}
make -j 2
make dist

%check
cd wilton
cd build
make test_js valgrind

%install
mkdir -p %{buildroot}/opt/wilton
cp -a wilton/build/wilton_%{version}/* %{buildroot}/opt/wilton/
mkdir -p %{buildroot}/opt/wilton/devel/debuginfo
cp -a wilton/build/wilton_%{version}_debuginfo/* %{buildroot}/opt/wilton/devel/debuginfo/
mkdir -p %{buildroot}/usr/bin
ln -s /opt/wilton/bin/wilton %{buildroot}/usr/bin/wilton

%files
/opt/wilton/*
/usr/bin/wilton

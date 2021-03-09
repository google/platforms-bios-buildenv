#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This generates a deterministic build environment.
# It is based on the Debian distribution and the debuerreotype project.
# Run this script as:
# $ sudo ./build.sh
# This will generate a rootfs.tar.xz that has an root image suitable to be used
# on a Docker container. A rootfs.sha256 contains a SHA256 checksum of the
# uncompressed and compressed images.
#
# When reviewing changes to this script, the reviewer must run the script
# locally and verify that the output matches the output on the review.

set -e
set -x

# Some configuration parameters.
# Update package list bellow.
DISTRO=buster
TIMESTAMP=2019-08-01T00:00:00Z

# Clean up previous artifacts.
rm -rf rootfs
rm -rf rootfs.sha256
rm -rf third_party/rootfs.tar
rm -rf third_party/rootfs.tar.xz
rm -rf debuerreotype

# Get a well know version of debuerreotype.
# Changes on debuerreotype can lead to changes on the output.
git clone --branch 0.10 --depth 1 https://github.com/debuerreotype/debuerreotype.git

BIN=debuerreotype/scripts

$BIN/debuerreotype-init rootfs $DISTRO $TIMESTAMP
$BIN/debuerreotype-minimizing-config rootfs
$BIN/debuerreotype-apt-get rootfs update -qq
$BIN/debuerreotype-apt-get rootfs dist-upgrade -yqq

# To work around Java SSL certificates not being deterministic do not install
# any SSL certs.
# Furthermore make sure that /bin/sh points to bash instead of dash.
$BIN/debuerreotype-apt-get rootfs install -yqq --no-install-recommends debconf-utils
$BIN/debuerreotype-chroot rootfs debconf-set-selections <<EOF
ca-certificates ca-certificates/enable_crts multiselect ""
ca-certificates ca-certificates/trust_new_crts select no
dash dash/sh boolean false
EOF

# Update this list to add software to the build environment.

$BIN/debuerreotype-apt-get rootfs install -yqq --no-install-recommends \
  acpica-tools \
  autoconf \
  automake \
  bc \
  binutils-multiarch \
  bison \
  build-essential \
  cpio \
  default-jre \
  device-tree-compiler \
  dkms \
  flex \
  gawk \
  gcc-aarch64-linux-gnu \
  git \
  libbsd-dev \
  libc6-dev-arm64-cross \
  libc6-i386 \
  libfdt-dev \
  libglib2.0-dev \
  libjson-c-dev \
  libpcre3-dev \
  libssl-dev \
  libtool \
  libtool-bin \
  nasm \
  protobuf-compiler \
  python3 \
  python3-cffi \
  python3-colorama \
  python3-crcmod \
  python3-cryptography \
  python3-lxml \
  python3-pycparser \
  python3-six \
  python3-yapsy \
  python-distutils-extra \
  python-protobuf \
  squashfs-tools \
  uuid-dev \
  zlib1g-dev

# Install wine
$BIN/debuerreotype-chroot rootfs dpkg --add-architecture i386
$BIN/debuerreotype-apt-get rootfs update -qq
$BIN/debuerreotype-apt-get rootfs dist-upgrade -yqq
$BIN/debuerreotype-apt-get rootfs install -yqq --no-install-recommends \
  wine \
  wine32 \
  wine64 \
  libwine \
  fonts-wine

$BIN/debuerreotype-debian-sources-list rootfs $DISTRO

# Delete cached Python and Java bytecode.
find -type d -name  __pycache__ -prune  -exec rm -r "{}" \;
find -type f -name '*.pyc' -prune  -exec rm -r "{}" \;
find -type f -name '*.jsa' -prune  -exec rm -r "{}" \;

$BIN/debuerreotype-tar rootfs third_party/rootfs.tar
sha256sum third_party/rootfs.tar > rootfs.sha256
xz third_party/rootfs.tar
sha256sum third_party/rootfs.tar.xz >> rootfs.sha256

chown --reference=build.sh third_party/rootfs.tar.xz rootfs.sha256

rm -rf rootfs
rm -rf debuerreotype

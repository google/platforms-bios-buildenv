#!/bin/bash

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
rm -rf rootfs.tar
rm -rf rootfs.tar.xz
rm -rf debuerreotype

# Get a well know version of debuerreotype.
# Changes on debuerreotype can lead to changes on the output.
git clone --branch 0.10 --depth 1 https://github.com/debuerreotype/debuerreotype.git

BIN=debuerreotype/scripts

$BIN/debuerreotype-init rootfs $DISTRO $TIMESTAMP
$BIN/debuerreotype-minimizing-config rootfs
$BIN/debuerreotype-apt-get rootfs update -qq
$BIN/debuerreotype-apt-get rootfs dist-upgrade -yqq

# Update this list to add software to the build environment.

$BIN/debuerreotype-apt-get rootfs install -yqq --no-install-recommends \
  acpica-tools \
  bc \
  bison \
  build-essential \
  flex \
  git \
  nasm \
  python-distutils-extra \
  uuid-dev \

$BIN/debuerreotype-debian-sources-list rootfs $DISTRO

# Delete cached Python bytecode.
find -type d -name  __pycache__ -prune  -exec rm -r "{}" \;

$BIN/debuerreotype-tar rootfs rootfs.tar
sha256sum rootfs.tar > rootfs.sha256
xz rootfs.tar
sha256sum rootfs.tar.xz >> rootfs.sha256

chown --reference=build.sh rootfs.tar.xz rootfs.sha256

rm -rf rootfs
rm -rf debuerreotype

#!/bin/sh
# SPDX-FileCopyrightText: 2026 ALKONTEK
# SPDX-License-Identifier: BSD-3-Clause

set -e

if [ -z "$1" ]; then
    echo "error: repository path required as first argument" >&2
    exit 1
fi
repo_path=$1

# Get version slug
package_name=JoltPhysics
version_hash=$(git describe --tags --match "v*" | sed 's/^v//' | sed 's/-/./g')
echo "** repository hash: ${version_hash} ..."

# Create dir tree for rpmbuild in user dir
rpmdev-setuptree

# Archive repository
(cd "${repo_path}" && git archive --format=tar.gz --prefix=${package_name}-${version_hash}/ -o ~/rpmbuild/SOURCES/${package_name}-${version_hash}.tar.gz HEAD)
echo "** created archive: ~/rpmbuild/SOURCES/${package_name}-${version_hash}.tar.gz"
sleep 2

# Download VulkanSDK (if don't exist)
if [ -d ~/VulkanSDK/1.4.350.0 ]; then
  echo "Vulkan SDK directory exists"
else
  echo "Vulkan SDK directory does NOT exist, downloading SDK ..."
  (
    mkdir -p ~/VulkanSDK
    cd ~/VulkanSDK
    curl -L -O https://sdk.lunarg.com/sdk/download/1.4.350.0/linux/vulkansdk-linux-x86_64-1.4.350.0.tar.xz
    tar xf vulkansdk-linux-x86_64-1.4.350.0.tar.xz
  )
fi

# Replace spec version
sed -i "s/Version:.\+/Version: ${version_hash}/g" ${package_name}.spec
echo "** building package version: ${version_hash}"

# Check dependencies
sudo dnf builddep -y ${package_name}.spec

# Build package, let it automatically download extra sources
rpmbuild --define "debug_package %{nil}" --clean -bb ${package_name}.spec

echo "** packages for ${package_name}-${version_hash} complete:"
ls ~/rpmbuild/RPMS/$(uname -m)/${package_name}-*${version_hash}*.rpm | cat

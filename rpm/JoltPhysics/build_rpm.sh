#!/bin/sh
# SPDX-FileCopyrightText: 2026 ALKONTEK
# SPDX-License-Identifier: BSD-3-Clause

set -e

package_name="JoltPhysics"
package_ver="5.6.0"

# Create dir tree for rpmbuild in user dir
rpmdev-setuptree

# Download Sources
curl -L -o ~/rpmbuild/SOURCES/${package_name}-${package_ver}.tar.gz \
  https://github.com/jrouwe/JoltPhysics/archive/refs/tags/v5.6.0.tar.gz

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

# Check dependencies
sudo dnf builddep -y ${package_name}.spec

# Build package, let it automatically download extra sources
rpmbuild --define "debug_package %{nil}" --clean -bb ${package_name}.spec

echo "** packages for ${package_name}-${version_hash} complete:"
ls ~/rpmbuild/RPMS/$(uname -m)/${package_name}-*${version_hash}*.rpm | cat

# Fedora Linux – Jolt Physics Build Instructions 

The following instructions are for building shared and static artifacts that
can be integrated into most RHEL systems.

## Build tools

Install the required packages:
```bash
sudo dnf install cmake gcc-c++ make ninja-build \
vulkan-headers vulkan-loader-devel
```
**CMake 3.20 or newer is required.**

Jolt's Vulkan support needs the DirectX Shader Compiler (`dxc`) from
the [LunarG Vulkan SDK](https://vulkan.lunarg.com/). Install the SDK, then put
its `bin` directory on your `PATH` (adjust the version/path if needed):

```bash
mkdir -p ~/VulkanSDK
cd ~/VulkanSDK
curl -L -O https://sdk.lunarg.com/sdk/download/1.4.350.0/linux/vulkansdk-linux-x86_64-1.4.350.0.tar.xz
tar xf vulkansdk-linux-x86_64-1.4.350.0.tar.xz
export PATH="${HOME}/VulkanSDK/${VULKAN_SDK_VERSION}/x86_64/bin${PATH:+:$PATH}"
```
Confirm `dxc` is available:
```bash
which dxc
```

## Prepare the build directory

```bash
mkdir -p build && cd build
```
**Use `-DCMAKE_INSTALL_PREFIX=...` in any build variant if you want a custom
installation prefix.**

## Release shared library (`libJolt.so`)
```bash
cmake -S . -B build/linux_release_shared \
-DCMAKE_CXX_COMPILER=g++ \
-DENABLE_INSTALL=ON \
-DTARGET_UNIT_TESTS=OFF \
-DTARGET_HELLO_WORLD=OFF \
-DTARGET_PERFORMANCE_TEST=OFF \
-DTARGET_SAMPLES=OFF \
-DTARGET_VIEWER=OFF \
-DJPH_USE_VK=ON \
-DJPH_USE_DX12=OFF \
-DJPH_USE_MTL=OFF \
-DJPH_USE_CPU_COMPUTE=ON \
-DINTERPROCEDURAL_OPTIMIZATION=ON \
-DGENERATE_DEBUG_SYMBOLS=ON \
-DPROFILER_IN_DEBUG_AND_RELEASE=OFF \
-DDEBUG_RENDERER_IN_DEBUG_AND_RELEASE=ON \
-DCPP_RTTI_ENABLED=ON \
-DCPP_EXCEPTIONS_ENABLED=ON \
-DCMAKE_BUILD_TYPE=Release \
-DJPH_BUILD_SHARED_LIBS=ON \
-DBUILD_SHARED_LIBS=ON

cmake --build build/linux_release_shared --parallel "$(nproc)"
```
Optional install:
```bash
cmake --install build/linux_release_shared
```

## Unit tests (optional)

To build and run tests, add `-DTARGET_UNIT_TESTS=ON` to the CMake configure
step, (for example, on the Release shared build):
```bash
./build/linux_release_shared/UnitTests
```

## Other variants

### Release static library (`libJolt.a`)
```bash
cmake -S . -B build/linux_release \
-DCMAKE_CXX_COMPILER=g++ \
-DENABLE_INSTALL=ON \
-DTARGET_UNIT_TESTS=OFF \
-DTARGET_HELLO_WORLD=OFF \
-DTARGET_PERFORMANCE_TEST=OFF \
-DTARGET_SAMPLES=OFF \
-DTARGET_VIEWER=OFF \
-DJPH_USE_VK=ON \
-DJPH_USE_DX12=OFF \
-DJPH_USE_MTL=OFF \
-DJPH_USE_CPU_COMPUTE=ON \
-DINTERPROCEDURAL_OPTIMIZATION=ON \
-DGENERATE_DEBUG_SYMBOLS=ON \
-DPROFILER_IN_DEBUG_AND_RELEASE=OFF \
-DDEBUG_RENDERER_IN_DEBUG_AND_RELEASE=ON \
-DCPP_RTTI_ENABLED=ON \
-DCPP_EXCEPTIONS_ENABLED=ON \
-DCMAKE_BUILD_TYPE=Release \
-DJPH_BUILD_SHARED_LIBS=OFF \
-DBUILD_SHARED_LIBS=OFF

cmake --build build/linux_release --parallel "$(nproc)"
# cmake --install build/linux_release
```
### Debug static library (`libJolt-d.a`)
```bash
cmake -S . -B build/linux_debug \
-DCMAKE_CXX_COMPILER=g++ \
-DENABLE_INSTALL=ON \
-DTARGET_UNIT_TESTS=OFF \
-DTARGET_HELLO_WORLD=OFF \
-DTARGET_PERFORMANCE_TEST=OFF \
-DTARGET_SAMPLES=OFF \
-DTARGET_VIEWER=OFF \
-DJPH_USE_VK=ON \
-DJPH_USE_DX12=OFF \
-DJPH_USE_MTL=OFF \
-DJPH_USE_CPU_COMPUTE=ON \
-DINTERPROCEDURAL_OPTIMIZATION=ON \
-DGENERATE_DEBUG_SYMBOLS=ON \
-DPROFILER_IN_DEBUG_AND_RELEASE=OFF \
-DDEBUG_RENDERER_IN_DEBUG_AND_RELEASE=ON \
-DCPP_RTTI_ENABLED=ON \
-DCPP_EXCEPTIONS_ENABLED=ON \
-DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_DEBUG_POSTFIX=-d \
-DENABLE_ALL_WARNINGS=OFF \
-DJPH_BUILD_SHARED_LIBS=OFF \
-DBUILD_SHARED_LIBS=OFF

cmake --build build/linux_debug --parallel "$(nproc)"
# cmake --install build/linux_debug
```

### Debug shared library (`libJolt-d.so`)
```bash
cmake -S . -B build/linux_debug_shared \
-DCMAKE_CXX_COMPILER=g++ \
-DENABLE_INSTALL=ON \
-DTARGET_UNIT_TESTS=OFF \
-DTARGET_HELLO_WORLD=OFF \
-DTARGET_PERFORMANCE_TEST=OFF \
-DTARGET_SAMPLES=OFF \
-DTARGET_VIEWER=OFF \
-DJPH_USE_VK=ON \
-DJPH_USE_DX12=OFF \
-DJPH_USE_MTL=OFF \
-DJPH_USE_CPU_COMPUTE=ON \
-DINTERPROCEDURAL_OPTIMIZATION=ON \
-DGENERATE_DEBUG_SYMBOLS=ON \
-DPROFILER_IN_DEBUG_AND_RELEASE=OFF \
-DDEBUG_RENDERER_IN_DEBUG_AND_RELEASE=ON \
-DCPP_RTTI_ENABLED=ON \
-DCPP_EXCEPTIONS_ENABLED=ON \
-DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_DEBUG_POSTFIX=-d \
-DENABLE_ALL_WARNINGS=OFF \
-DJPH_BUILD_SHARED_LIBS=ON \
-DBUILD_SHARED_LIBS=ON

cmake --build build/linux_debug_shared --parallel "$(nproc)"
# cmake --install build/linux_debug_shared
```


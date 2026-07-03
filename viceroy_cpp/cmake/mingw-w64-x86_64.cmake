# Cross-compile Forge for Windows x64 from Linux with MinGW-w64:
#   cmake -S viceroy_cpp -B build-win -DCMAKE_TOOLCHAIN_FILE=viceroy_cpp/cmake/mingw-w64-x86_64.cmake
#   cmake --build build-win -j8 --target forge
# The result (build-win/Forge.exe) is fully static (no MinGW DLLs) and has no
# other dependencies: libpng/SDL2 are only used by the asset importer and the
# game-runtime targets, which are skipped when they aren't found for the
# target platform.
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)
set(CMAKE_FIND_ROOT_PATH /usr/x86_64-w64-mingw32)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_EXE_LINKER_FLAGS_INIT "-static -static-libgcc -static-libstdc++")

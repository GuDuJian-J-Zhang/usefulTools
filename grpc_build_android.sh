#for grpc v1.60.0 (https://github.com/grpc/grpc/tree/v1.60.0)
mkdir grpc_cmake

cd grpc_cmake

#cmake ../ -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/build/cmake/android.toolchain.cmake" -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-29 -DANDROID_STL=c++_static -DCMAKE_MAKE_PROGRAM=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/prebuilt/windows-x86_64/bin/make.exe -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=D:/gudujian/software/grpc/Android/Release -DCMAKE_BUILD_TYPE=MinSizeRel -DINSTALL_LIB_DIR=D:/gudujian/software/grpc/Android/Release/lib -DINSTALL_INC_DIR=D:/gudujian/software/grpc/Android/Release/include -DINSTALL_BIN_DIR=D:/gudujian/software/grpc/Android/Release/bin -DCMAKE_C_COMPILER=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/toolchains/llvm/prebuilt/windows-x86_64/bin/clang.exe -DCMAKE_CXX_COMPILER=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/toolchains/llvm/prebuilt/windows-x86_64/bin/clang++.exe  -DBUILD_SHARED_LIBS=ON -D_gRPC_CPP_PLUGIN=D:/gudujian/software/grpc/bin/grpc_cpp_plugin.exe -D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=D:/gudujian/software/grpc/bin/protoc.exe

cmake ../ -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/build/cmake/android.toolchain.cmake" -DANDROID_ABI=arm64-v8a -DANDROID_NDK="C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313" -DANDROID_PLATFORM=android-29 -DCMAKE_MAKE_PROGRAM=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/prebuilt/windows-x86_64/bin/make.exe -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=D:/gudujian/software/grpc/Android/Release-Static -DCMAKE_BUILD_TYPE=MinSizeRel -DINSTALL_LIB_DIR=D:/gudujian/software/grpc/Android/Release-Static/lib -DINSTALL_INC_DIR=D:/gudujian/software/grpc/Android/Release-Static/include -DINSTALL_BIN_DIR=D:/gudujian/software/grpc/Android/Release-Static/bin -DCMAKE_C_COMPILER=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/toolchains/llvm/prebuilt/windows-x86_64/bin/clang.exe -DCMAKE_CXX_COMPILER=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/toolchains/llvm/prebuilt/windows-x86_64/bin/clang++.exe  -DBUILD_SHARED_LIBS=OFF -D_gRPC_CPP_PLUGIN=D:/gudujian/software/grpc/bin/grpc_cpp_plugin.exe -D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=D:/gudujian/software/grpc/bin/protoc.exe

make && make install
#cmake ../ -G "Unix Makefiles" -DANDROID_ABI=arm64-v8a -DANDROID_NDK=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313 -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/prebuilt/windows-x86_64/bin/make.exe -DCMAKE_TOOLCHAIN_FILE="C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/build/cmake/android.toolchain.cmake" -DANDROID_PLATFORM=latest -DANDROID_STL=gnustl_static -DANDROID_TOOLCHAIN=gcc -DCMAKE_INSTALL_PREFIX=D:/gudujian/software/grpc/Android/Release -D_gRPC_CPP_PLUGIN=D:/gudujian/software/grpc/bin/grpc_cpp_plugin.exe -D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=D:/gudujian/software/grpc/bin/protoc.exe


#cmake ../ -G "Ninja" -DANDROID_ABI=arm64-v8a -DANDROID_NDK=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313 -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM="C:/Program Files/CMake/bin/ninja.exe" -DCMAKE_TOOLCHAIN_FILE=C:/Users/Jun.Zhang/AppData/Local/Android/Sdk/ndk/23.2.8568313/prebuilt/windows-x86_64/bin/make.exe -DANDROID_PLATFORM=android-33 -DANDROID_STL=gnustl_static -DANDROID_TOOLCHAIN=gcc -DCMAKE_INSTALL_PREFIX=D:/gudujian/software/grpc/Android/Release -D_gRPC_CPP_PLUGIN=D:/gudujian/software/grpc/bin/grpc_cpp_plugin.exe -D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=D:/gudujian/software/grpc/bin/protoc.exe
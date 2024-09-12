#!/bin/sh
source ~/bin/android-env.sh
top=`pwd`
cd ../source/onnxruntime
set -e
# arm64-v8a
archs=( armeabi-v7a  x86 x86_64 arm64-v8a)

IFS=' '
for arch in ${archs[@]}; do	
   echo build - $arch
   if [ "$arch" = "arm64-v8a" ]; then 
	  arg="--use_nnapi" 
	  API=23
   elif [ "$arch" = "armeabi-v7a" ]; then 
 	  API=21   
   else 
	  API=23
   fi
   find android-onnx-build/$arch -iname 'CMakeCache.txt' -delete
   ./build.sh --android \
    --android_sdk_path $ANDROID_HOME \
    --android_ndk_path $ANDROID_NDK_HOME \
    --android_abi "$arch"  --android_api $API \
	--skip_tests \
    $arg --parallel\
    --build_shared_lib --config MinSizeRel --build_dir android-onnx-build/$arch \
	--cmake_extra_defines CMAKE_INSTALL_PREFIX=$top/../onnxruntime/$arch && \
    pushd android-onnx-build/$arch/MinSizeRel && \
    cmake -P cmake_install.cmake && \
    popd 
done

#!/bin/sh
if [ -e ~/bin/android-env.sh ]; then 
		source ~/bin/android-env.sh
fi
set -e
top=`pwd`
bdir="build/onnx-android"
mkdir -p $bdir
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
   if [ -d $bdir/$arch ]; then 
   	  find $bdir/$arch -iname 'CMakeCache.txt' -delete
   fi
   ../onnxruntime/build.sh --android \
	--build_dir $bdir/$arch \
    --android_sdk_path $ANDROID_HOME \
    --android_ndk_path $ANDROID_NDK_HOME \
    --android_abi "$arch"  --android_api $API \
	--skip_tests \
    $arg --parallel\
    --build_shared_lib --config MinSizeRel  \
	--cmake_extra_defines CMAKE_INSTALL_PREFIX=$top/../android/onnxruntime/$arch && \
    pushd $bdir/$arch/MinSizeRel && \
    cmake -P cmake_install.cmake && \
    popd 
done

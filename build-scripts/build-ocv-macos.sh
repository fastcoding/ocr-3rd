#!/bin/bash

set -o errexit
set -o pipefail
script_dir=$(pwd)
top=$script_dir
bdir="build/ocv-mac"
mkdir -p $bdir
#set -o nounset
setup_opencv()
{
    printf "*********************************\n${FUNCNAME[0]}\n"
    #########################################
	mkdir -p $bdir/opencv
	printf "copying..\n"
	cp -r ../source/opencv/* $bdir/opencv/ 
    pushd $bdir/opencv 
	patch -p1 <$top/patch-ocv-mac.txt
	popd
    #########################################
    printf "build\n"
	
    pushd $bdir
    
	mkdir -p macos_build
    
	cd macos_build
	
	rm -rf ../opencv/3rdparty/libpng
	
	export LIBPNG_Dir=$script_dir/../mac/libpng
	export PNG_LIBRARY=$script_dir/../mac/libpng/lib/libpng.a
	export PNG_INCLUDE_DIR=$script_dir/../mac/libpng/include
	export PNG_DIR=$script_dir/../mac/libpng/lib/libpng

    python ../opencv/platforms/osx/build_framework.py \
			--disable=obsensor \
			--disable=video \
			--without=java \
			--disable=ffmpeg \
			--disable=vtk \
			--disable=openvino \
			--macosx_deployment_target=12.0 \
			--macos_archs="arm64,x86_64" osx
    
    #########################################
	
    printf "move framework\n"
	rm -rf $top/../mac/opencv2.framework
    mv osx/opencv2.framework $top/../mac/
   
    popd
    #########################################
    rm -rf $bdir
    #rm -Rf ${BASE_PATH}/opencv/macos_build
    
}

if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then 
	export MACOSX_DEPLOYMENT_TARGET=12.0
fi

setup_opencv 

#!/bin/bash

set -o errexit
set -o pipefail
script_dir=$(pwd)
#set -o nounset
setup_opencv()
{
    printf "*********************************\n${FUNCNAME[0]}\n"
    local readonly PARENT_FOLDER=${1:-third_party}
	local readonly BASE_PATH=$(cd $CURRENT_PATH/$PARENT_FOLDER;pwd)
    
    #########################################
    mkdir -p ${BASE_PATH}/opencv/source/
    cd ${BASE_PATH}/opencv/source/
	if [ -d ${BASE_PATH}/source/opencv ]; then 
		rm -rf opencv
    	printf "copying..\n"
		cp -r ${BASE_PATH}/source/opencv/* . 
	else
    	printf "download\n"
        git clone https://github.com/opencv/opencv.git .
	fi
    
    #########################################
    printf "build\n"
    cd ${BASE_PATH}/opencv/
    mkdir -p macos_build
    cd ${BASE_PATH}/opencv/macos_build
	rm -rf ../source/3rdparty/libpng
	export LIBPNG_Dir=$script_dir/../source/libpng/products/universal
	export PNG_LIBRARY=$script_dir/../source/libpng/products/universal/lib/libpng.a
	export PNG_INCLUDE_DIR=$script_dir/../source/libpng/products/universal/include
	export PNG_DIR=$script_dir/../source/libpng/products/universal/lib/libpng

    python ../source/platforms/osx/build_framework.py --disable=obsensor --disable=video \
			--without=java \
			--disable=ffmpeg \
			--disable=vtk \
			--disable=openvino \
			--macosx_deployment_target=12.0 \
			--macos_archs="arm64,x86_64" osx
    
    #########################################
    printf "move framework\n"
    mkdir -p ${BASE_PATH}/opencv/mac/
    mv osx/opencv2.framework/ ${BASE_PATH}/opencv/mac/opencv2.framework/
    
    #########################################
    printf "delete source and build folder\n"
    cd ${BASE_PATH}/opencv/
    rm -Rf ${BASE_PATH}/opencv/source
    #rm -Rf ${BASE_PATH}/opencv/macos_build
    
    cd $CURRENT_PATH
}

main()
{
	if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then 
		export MACOSX_DEPLOYMENT_TARGET=12.0
	fi
	
    local PARENT_PATH=${1:?"You need to pass in a parent folder"}
    setup_opencv $PARENT_PATH
}

CURRENT_PATH=$PWD
if [ -z "$1" ]; then 
	rel=".."
else
	rel=$1
fi
main $rel

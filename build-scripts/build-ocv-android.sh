#!/bin/sh
OPENCV_SRC_FOLDER=$(cd ../source/opencv;pwd)
export OPENCV_SRC_FOLDER
if [ -e ~/bin/android-env.sh ]; then 
	source ~/bin/android-env.sh
fi 
bdir=build/opencv-android
mkdir -p $bdir
#--extra_modules_path $YOUR_CONTRIB_SRC_FOLDER/modules 
python3 $OPENCV_SRC_FOLDER/platforms/android/build_sdk.py \
     $bdir $OPENCV_SRC_FOLDER \
     --ndk_path $ANDROID_NDK_HOME \
     --sdk_path $ANDROID_SDK \
     --config $OPENCV_SRC_FOLDER/platforms/android/ndk-18-api-level-21.config.py \
     --use_android_buildtools && \
rm -rf ../android/opencv2 && \
mv $bdir/OpenCV-android-sdk ../android/opencv2

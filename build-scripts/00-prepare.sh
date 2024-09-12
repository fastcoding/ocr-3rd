#!/bin/sh 
mkdir -p ../source
git clone --depth 1 -b 4.10.0 --recurse-submodules https://github.com/opencv/opencv.git  ../source/opencv
git clone --depth 1 -b v1.17.3 --recurse-submodules https://github.com/microsoft/onnxruntime.git  ../source/onnxruntime
git clone --depth 1 -b v1.16.43 https://github.com/pnggroup/libpng.git  ../source/libpng


# ladi-vton-pipeline

## Installation

### Openpose
```
cmake \
BUILD_CAFFE=ON \
BUILD_DOCS=OFF \
BUILD_EXAMPLES=ON \
BUILD_PYTHON=OFF \
BUILD_SHARED_LIBS=ON \
BUILD_UNITY_SUPPORT=OFF \
CMAKE_BUILD_TYPE=Release \
CMAKE_INSTALL_PREFIX=/usr/local \
CUDA_ARCH=Auto \
CUDA_HOST_COMPILER=/usr/bin/cc \
CUDA_TOOLKIT_ROOT_DIR=/home/nsynk/anaconda3/envs/mega-vton \
CUDA_USE_STATIC_CUDA_RUNTIME=ON \
CUDA_CUDART_LIBRARY=/home/nsynk/anaconda3/envs/mega-vton/lib/libcudart.so \
Caffe_INCLUDE_DIRS:PATH=/usr/local/include/caffe \
Caffe_LIBS:FILEPATH=/usr/local/lib/libcaffe.dylib \
DL_FRAMEWORK:STRING=CAFFE \
DOWNLOAD_BODY_25_MODEL:BOOL=ON \
DOWNLOAD_BODY_COCO_MODEL:BOOL=OFF \
DOWNLOAD_BODY_MPI_MODEL:BOOL=OFF \
DOWNLOAD_FACE_MODEL:BOOL=ON \
DOWNLOAD_HAND_MODEL:BOOL=ON \
GPU_MODE:STRING="CUDA" \
INSTRUCTION_SET:STRING=NONE \
OpenCV_DIR:PATH=/usr/lib/x86_64-linux-gnu/cmake/opencv4 \
PROFILER_ENABLED:BOOL=OFF \
USE_CUDNN:BOOL=OFF \
WITH_3D_RENDERER:BOOL=OFF \
WITH_CERES:BOOL=OFF \
WITH_EIGEN:STRING=NONE\
WITH_FLIR_CAMERA:BOOL=OFF \
WITH_OPENCV_WITH_OPENGL:BOOL=OFF \
-S ../ -B ./
```

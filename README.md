# ladi-vton-pipeline

## Installation

### Openpose

```
git submodule update --init --recursive --remote

mkdir openpose/build/

cd openpose/build

cmake \
-D BUILD_CAFFE=ON \
-D BUILD_DOCS=OFF \
-D BUILD_EXAMPLES=ON \
-D BUILD_PYTHON=OFF \
-D BUILD_SHARED_LIBS=ON \
-D BUILD_UNITY_SUPPORT=OFF \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D CUDA_ARCH=Auto \
-D CUDA_HOST_COMPILER=/usr/bin/cc \
-D CUDA_TOOLKIT_ROOT_DIR=/home/nsynk/anaconda3/envs/mega-vton \
-D CUDA_USE_STATIC_CUDA_RUNTIME=ON \
-D CUDA_CUDART_LIBRARY=/home/nsynk/anaconda3/envs/mega-vton/lib/libcudart.so \
-D DL_FRAMEWORK=CAFFE \
-D DOWNLOAD_BODY_25_MODEL=ON \
-D DOWNLOAD_BODY_COCO_MODEL=OFF \
-D DOWNLOAD_BODY_MPI_MODEL=OFF \
-D DOWNLOAD_FACE_MODEL=ON \
-D DOWNLOAD_HAND_MODEL=ON \
-D GPU_MODE="CUDA" \
-D INSTRUCTION_SET=NONE \
-D OpenCV_DIR=/usr/lib/x86_64-linux-gnu/cmake/opencv4 \
-D PROFILER_ENABLED=OFF \
-D USE_CUDNN=OFF \
-D WITH_3D_RENDERER=OFF \
-D WITH_CERES=OFF \
-D WITH_EIGEN=NONE\
-D WITH_FLIR_CAMERA=OFF \
-D WITH_OPENCV_WITH_OPENGL=OFF \
-S ../ -B ./

make -j`nproc`
```
### Human Parse

```
python3 -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
```

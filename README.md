# ladi-vton-pipeline

```

#install build dependencies
sudo apt-get -qq install -y libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libgflags-dev libgoogle-glog-dev liblmdb-dev opencl-headers ocl-icd-opencl-dev libviennacl-dev libboost-all-dev

#install miniconda

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
eval "$(~/miniconda3/bin/conda shell.bash hook)"
conda init

#install cuda and cudnn
sudo apt-get install linux-headers-$(nsynk -r)
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb

sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list'
sudo apt update

sudo apt-get install cuda-10-2

sudo apt-get install libcudnn7
sudo apt-get install libcudnn7-dev

wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/cudnn-10.2-linux-x64-v7.6.5.32.tgz

#install tensorflow

conda install -c "nvidia/label/cuda-10.2.0" cuda-toolkit
python -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

#get the repo
mkdir repositories
git clone https://github.com/umanema/ladi-vton-pipeline.git
cd repositories/
git submodule update --init --recursive
```

## Installation

### Openpose

```
# install cmake
sudo apt-get update
sudo apt  install cmake

conda  conda install -c anaconda libffi=3.3 #wsl libffi bug
conda install -c conda-forge opencv
sudo apt install caffe-cpu

cd repositories/ladi-vton-pipeline/openpose/
git submodule update --init --recursive --remote

mkdir build/
cd build/

cmake -D USE_CUDNN=OFF -S ../ -B ./

<!-- cmake \
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
-D CUDA_CUDART_LIBRARY=/home/nsynk/anaconda3/envs/mega-vton/lib/libcudart.so \
-D CUDA_USE_STATIC_CUDA_RUNTIME=ON \
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
-S ../ -B ./ -->

make -j`nproc`
```
### Human Parse

```
python -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
```

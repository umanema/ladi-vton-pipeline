# ladi-vton-pipeline


## Installation

Get the repository
```
mkdir repositories
cd ~/repositories
git clone https://github.com/umanema/ladi-vton-pipeline.git
git submodule update --init --recursive
```
You can either use an installation script 
```
cd ~/repositories/ladi-vton-pipeline/auto-vton
bash install.sh
```
Or do everything yourself with CLI

```
#install miniconda

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
eval "$(~/miniconda3/bin/conda shell.bash hook)"
conda init

#install carvekit before everything else
pip install carvekit

#install cuda and cudnn

sudo apt-get install linux-headers-$(nsynk -r)
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get install cuda-11-8

#install tensorflow

conda install -c "nvidia/label/cuda-11.8.0" cuda-toolkit
python -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
```

### Openpose

```
# install build dependencies
sudo apt-get -qq install -y libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libgflags-dev libgoogle-glog-dev liblmdb-dev opencl-headers ocl-icd-opencl-dev libviennacl-dev libboost-all-dev

# install cmake
sudo apt-get update
sudo apt-get  install cmake
sudo apt-ge install libopencv-dev python3-opencv

# when running on wsl
conda  conda install -c anaconda libffi=3.3

# install protobuf
sudo apt-get install libprotobuf-dev protobuf-compiler

cd ~/repositories/ladi-vton-pipeline/openpose/
git submodule update --init --recursive --remote

mkdir build/
cd build/



cmake -D USE_CUDNN=ON -D CUDNN_LIBRARY="$CUDNN_PATH/lib" -D CUDNN_INCLUDE="$CUDNN_PATH/include"  -S ../ -B ./
make -j`nproc`
```

#### Useful cmake flags
```
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
-D CUDA_TOOLKIT_ROOT_DIR= \
-D CUDA_CUDART_LIBRARY= \
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
-D CUDNN_LIBRARY= \
-D CUDNN_INCLUDE=
-D WITH_3D_RENDERER=OFF \
-D WITH_CERES=OFF \
-D WITH_EIGEN=NONE\
-D WITH_FLIR_CAMERA=OFF \
-D WITH_OPENCV_WITH_OPENGL=OFF \
-S ../ -B ./
```
### Human Parse

```
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install tf_slim
pip install matplotlib
pip install gdown
sudo apt-get install unzip

cd ~/repositories/CHIP_PGN
gdown --id=1Mqpse5Gen4V4403wFEpv3w3JAsWw2uhk
unzip CIHP_pgn.zip
mv ./CIHP_pgn ./CIHP_PGN/checkpoint/
```

### Dense Pose

```
cd ~/repositories/ladi-vton-pipeline
python -m pip install -e detectron2
python -m pip install av
pip install accelerate
```

### Ladi Vton
```
pip install diffusers==0.14.0 transformers==4.27.3 accelerate==0.18.0 clean-fid==0.1.35 torchmetrics[image]==0.11.4 wandb==0.14.0 matplotlib==3.7.2 tqdm xformers
```
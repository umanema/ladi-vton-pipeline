#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})

source $USER_HOME/miniconda3/etc/profile.d/conda.sh
conda activate ladi-vton-pipeline

#build openpose
#start with dependencies
sudo apt-get update
sudo apt-get -qq install -y --no-upgrade libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libgflags-dev libgoogle-glog-dev liblmdb-dev opencl-headers ocl-icd-opencl-dev libviennacl-dev libboost-all-dev libopencv-dev python3-opencv cmake

#miniconda might have issues with std libs so I link it to the one installed with apt
ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 $CONDA_PREFIX/lib/libstdc++.so.6

cd $USER_HOME/repositories/ladi-vton-pipeline/openpose

sudo rm -rf ./build
mkdir build/
cd build/

echo "building openpose"
sudo cmake -D USE_CUDNN=ON -D CUDNN_LIBRARY="$CUDNN_PATH/lib" -D CUDNN_INCLUDE="$CUDNN_PATH/include"  -S ../ -B ./
sudo make -j`nproc`
echo "openpose finished building"

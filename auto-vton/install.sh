#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})
cd $USER_HOME/repositories/ladi-vton-pipeline
sudo git submodule update --init --recursive

cd $USER_HOME

#create folder structure
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/auto-vton/input/cloth
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/auto-vton/input/person
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/auto-vton/resize/cloth
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/auto-vton/resize/person
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/auto-vton/result

sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/agnostic-v3.2
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/cloth
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/cloth-mask
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image-densepose
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image-parse-agnostic-v3.2
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image-parse-v3
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/openpose_img
sudo mkdir -p $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/openpose_json
sudo touch $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test_pairs.txt
echo "person.jpg cloth.jpg" | sudo tee $USER_HOME/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test_pairs.txt

#install miniconda
MINICONDA=$USER_HOME/miniconda.sh
if [[ -f "$MINICONDA" ]]; then
    echo "miniconda is already installed on the system"
else
    echo "installing miniconda" 
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $USER_HOME/miniconda.sh
    sh $USER_HOME/miniconda.sh -b -p $USER_HOME/miniconda3 -u
    eval "$($USER_HOME/miniconda3/bin/conda shell.bash hook)"
fi
source $USER_HOME/miniconda3/etc/profile.d/conda.sh

if { conda env list | grep ladi-vton-pipeline ; } >/dev/null 2>&1 ; then
    echo "ladi-vton-anaconda already exists";
    conda activate ladi-vton-pipeline
else
    echo "creating ladi-vton pipeline env"
    conda create -n ladi-vton-pipeline python=3.10 -y
    conda activate ladi-vton-pipeline
fi
#install carvekit before everything else because it will have conflicts with pytorch version we are going to install later
if python -c "import carvekit" &> /dev/null; then
    echo 'carvekit is already installed'
else
    echo 'installing carvekit'
    pip install --no-input carvekit
fi
#install cuda and cudnn
sudo apt-get install linux-headers-`uname -r`
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update

sudo apt-get -qq install --yes --no-upgrade cuda-11-8

#install tensorflow
conda install -y -c "nvidia/label/cuda-11.8.0" cuda-toolkit
python -m pip install --no-input nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
echo $CONDA_PREFIX
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

#build openpose
#start with dependencies
sudo apt-get update
sudo apt-get -qq install -y --no-upgrade libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libgflags-dev libgoogle-glog-dev liblmdb-dev opencl-headers ocl-icd-opencl-dev libviennacl-dev libboost-all-dev libopencv-dev python3-opencv cmake

#miniconda might have issues with std libs so I link it to the one installed with apt
ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 $CONDA_PREFIX/lib/libstdc++.so.6

cd $USER_HOME/repositories/ladi-vton-pipeline/openpose
# git submodule update --init --recursive --remote

mkdir build/
cd build/

BIN=./examples/openpose/openpose.bin
if [[ -f "$BIN" ]]; then
    echo "openpose is already built"
else
    echo "building openpose"
    sudo cmake -D USE_CUDNN=ON -D CUDNN_LIBRARY="$CUDNN_PATH/lib" -D CUDNN_INCLUDE="$CUDNN_PATH/include"  -S ../ -B ./
    sudo make -j`nproc`
    echo "openpose finished building"
fi
#prepare CIHP_pgn repo for human parsing
pip install --no-input torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install --no-input tf_slim matplotlib gdown

sudo apt-get -qq install -y --no-upgrade unzip
cd $USER_HOME/repositories/ladi-vton-pipeline/CIHP_PGN
#donwload weights
CHECKPOINT=./checkpoint/CIHP_pgn/
if [[ -d "$CHECKPOINT" ]]; then
    echo "checkpoint CIHP_pgn already exist"
else
    gdown --id "1Mqpse5Gen4V4403wFEpv3w3JAsWw2uhk"
    unzip CIHP_pgn.zip
    sudo mkdir -p ./checkpoint/CIHP_pgn
    sudo mv ./CIHP_pgn/* ./checkpoint/CIHP_pgn/
    sudo rm -f ./CIHP_pgn.zip
    sudo rm -rf ./CIHP_pgn
fi
#install densepose
cd $USER_HOME/repositories/ladi-vton-pipeline
if pip list | grep detectron2 &> /dev/null; then
    echo "detectron2 is already installed"
else
    sudo $CONDA_PREFIX/bin/python -m pip install -e detectron2
fi
python -m pip install --no-input av
pip install --no-input accelerate

#install ladi-vton dependencies
pip install --no-input diffusers==0.14.0 transformers==4.27.3 accelerate==0.18.0 clean-fid==0.1.35 torchmetrics[image]==0.11.4 wandb==0.14.0 matplotlib==3.7.2 tqdm xformers

#give permissions to write into input folders
#chmod -R a+rwX
chown "$(whoami)" .

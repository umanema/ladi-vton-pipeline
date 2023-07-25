cd ~/repositories
git submodule update --init --recursive --remote

#install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
eval "$(~/miniconda3/bin/conda shell.bash hook)"
conda init

conda create ladi-vton-pipeline
conda activate ladi-vton-pipeline

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

mkdir ~/repositories/ladi-vton-pipeline/auto-vton/input/cloth
mkdir ~/repositories/ladi-vton-pipeline/auto-vton/input/person
mkdir ~/repositories/ladi-vton-pipeline/auto-vton/resize/cloth
mkdir ~/repositories/ladi-vton-pipeline/auto-vton/resize/person
mkdir ~/repositories/ladi-vton-pipeline/auto-vton/result

mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/agnostic-v3.2
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/cloth
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/cloth-mask
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image-densepose
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image-parse-agnostic-v3.2
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/image-parse-v3
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/openpose_img
mkdir ~/repositories/ladi-vton-pipeline/ladi-vton/data/hd-viton/test/openpose_json

#openpose
sudo apt-get -qq install -y libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libgflags-dev libgoogle-glog-dev liblmdb-dev opencl-headers ocl-icd-opencl-dev libviennacl-dev libboost-all-dev

sudo apt-get update
sudo apt-get install cmake
sudo apt-ge install libopencv-dev python3-opencv
sudo apt-get install libprotobuf-dev protobuf-compiler

cd ~/repositories/ladi-vton-pipeline/openpose/
git submodule update --init --recursive --remote

mkdir build/
cd build/

cmake -D USE_CUDNN=ON -D CUDNN_LIBRARY="$CUDNN_PATH/lib" -D CUDNN_INCLUDE="$CUDNN_PATH/include"  -S ../ -B ./
make -j`nproc`

#humanparse

pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install tf_slim
pip install matplotlib
pip install gdown
sudo apt-get install unzip

cd ~/repositories/CHIP_PGN
gdown --id=1Mqpse5Gen4V4403wFEpv3w3JAsWw2uhk
unzip CIHP_pgn.zip
mv ./CIHP_pgn ./CIHP_PGN/checkpoint/

#densepose
cd ~/repositories/ladi-vton-pipeline
python -m pip install -e detectron2
python -m pip install av
pip install accelerate

#ladi-vton
pip install diffusers==0.14.0 transformers==4.27.3 accelerate==0.18.0 clean-fid==0.1.35 torchmetrics[image]==0.11.4 wandb==0.14.0 matplotlib==3.7.2 tqdm xformers
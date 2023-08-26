#!/bin/bash

USER_HOME=$(eval echo ~${SUDO_USER})
cd $USER_HOME
source $USER_HOME/miniconda3/etc/profile.d/conda.sh
conda activate ladi-vton-pipeline

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

#openpose
cd $USER_HOME/repositories/ladi-vton-pipeline/openpose

mkdir build/

BIN=./examples/openpose/openpose.bin
if [[ -f "$BIN" ]]; then
    echo "openpose is already built"
else
    echo "downloading openpose models"

    cd $USER_HOME/repositories/ladi-vton-pipeline/openpose

    #download openpose models from GDrive
    gdown --id "1QCSxJZpnWvM00hx49CJ2zky7PWGzpcEh"
    sudo unzip -o models.zip

    echo "building openpose"
    cd $USER_HOME/repositories/ladi-vton-pipeline/openpose/build
    sudo cmake -D USE_CUDNN=ON -D CUDNN_LIBRARY="$CUDNN_PATH/lib" -D CUDNN_INCLUDE="$CUDNN_PATH/include"  -S ../ -B ./
    sudo make -j`nproc`
    echo "openpose finished building"
fi

#CIHP_pgn
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

#give permissions to write into input folders
sudo chmod -R a+rwX .
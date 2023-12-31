#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})

readonly resize_person_folder="auto-vton/resize/person"
readonly resize_cloth_folder="auto-vton/resize/cloth"
readonly destination_folder="ladi-vton/data/hd-viton/test"

source $USER_HOME/miniconda3/etc/profile.d/conda.sh

conda activate ladi-vton-pipeline

sudo rm -rf ../$destination_folder/agnostic-v3.2/*
sudo rm -rf ../$destination_folder/cloth/*
sudo rm -rf ../$destination_folder/cloth-mask/*
sudo rm -rf ../$destination_folder/image/*
sudo rm -rf ../$destination_folder/image-parse-agnostic-v3.2/*
sudo rm -rf ../$destination_folder/image-parse-v3/*
sudo rm -rf ../$destination_folder/openpose_img/*
sudo rm -rf ../$destination_folder/openpose_json/*
sudo rm -rf ../ladi-vton/output/unpaired/upper_body/*


# Resize input pictures
echo "Resizing input picture to the size of 768x1024"
sudo $CONDA_PREFIX/bin/python ./src/preprocess/resize.py
sudo cp -rf "../$resize_person_folder/person.jpg" "../$destination_folder/image/person.jpg"
sudo cp -rf "../$resize_cloth_folder/cloth.jpg" "../$destination_folder/cloth/cloth.jpg"

# Openpose
echo "Start Openpose"
cd ../openpose
sudo ./build/examples/openpose/openpose.bin --image_dir "../$destination_folder/image/" --write_images "../$destination_folder/openpose_img" --write_json "../$destination_folder/openpose_json" --hand --display 0 --num_gpu 1 --num_gpu_start 0

# Human Parse
echo "Start Human Parse"
cd ../CIHP_PGN
#conda activate human-parse
sudo $CONDA_PREFIX/bin/python ./inf_pgn.py --directory "../$destination_folder/image/" --output "../$destination_folder/image-parse-v3"
sudo cp -rf "../$destination_folder/image-parse-v3/cihp_parsing_maps/person.png" "../$destination_folder/image-parse-v3/person.png"
sudo rm -r "../$destination_folder/image-parse-v3/cihp_edge_maps"
sudo rm -r "../$destination_folder/image-parse-v3/cihp_parsing_maps"

# DensePose
echo "Start DensePose"
cd ../detectron2/projects/DensePose
#conda activate densepose
sudo $CONDA_PREFIX/bin/python apply_net.py show configs/densepose_rcnn_R_50_FPN_s1x.yaml \
https://dl.fbaipublicfiles.com/densepose/densepose_rcnn_R_50_FPN_s1x/165712039/model_final_162be9.pkl \
"../../../$resize_person_folder" dp_segm -v

sudo cp -rf "./image-densepose/person.jpg" "../../../$destination_folder/image-densepose/person.jpg"

#Cloth Mask
echo "Create cloth mask"
cd ../../../auto-vton
#conda activate carvekit

sudo $CONDA_PREFIX/bin/python ./src/preprocess/maskcloth.py

#Parse
echo "Parse "
#conda activate ladi-vton
sudo $CONDA_PREFIX/bin/python ./src/preprocess/parse_agnostic.py
sudo $CONDA_PREFIX/bin/python ./src/preprocess/human_agnostic.py

#Process
echo "Start main processing"
cd ../ladi-vton
sudo $CONDA_PREFIX/bin/python ./src/inference.py --dataset vitonhd --vitonhd_dataroot ./data/hd-viton --output_dir ./output --test_order unpaired --enable_xformers_memory_efficient_attention

#Move results
cd ../auto-vton
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
sudo cp "../ladi-vton/output/unpaired/upper_body/person.jpg" "./result/$current_time.jpg"
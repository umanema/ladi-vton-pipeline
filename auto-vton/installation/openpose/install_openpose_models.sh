#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})

source $USER_HOME/miniconda3/etc/profile.d/conda.sh
conda activate ladi-vton-pipeline

cd $USER_HOME/repositories/ladi-vton-pipeline/openpose

#download openpose models from GDrive
gdown "1RosQj4dV6-EBniev8sz0V5ngW1FTnW9U"
sudo unzip -o models.zip
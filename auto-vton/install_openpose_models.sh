#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})

source $USER_HOME/miniconda3/etc/profile.d/conda.sh
conda activate ladi-vton-pipeline

cd $USER_HOME/repositories/ladi-vton-pipeline/openpose

#download openpose models from GDrive
gdown --id "1QCSxJZpnWvM00hx49CJ2zky7PWGzpcEh"
sudo unzip -o models.zip
#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})

cd $USER_HOME/repositories/ladi-vton-pipeline/openpose

#download openpose models from GDrive
gdown --id "1QCSxJZpnWvM00hx49CJ2zky7PWGzpcEh"
sudo unzip -o models.zip
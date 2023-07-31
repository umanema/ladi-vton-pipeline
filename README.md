# ladi-vton-pipeline
The main purpose of the repository is to collect all the tools you need to use [LaDI-VTON](https://github.com/miccunifi/ladi-vton.git) repository with custom input.

The pipeline is tested on ubuntu 20.04 and 22.04 with cuda capable GPU. Important to note that some of the repositories used in this project won't work anywhere except linux. Also I'm not sure how all of it gonna work withouth GPU support, but theoretically it could.

## Installation

Get the repository
```
mkdir repositories
cd ~/repositories
git clone https://github.com/umanema/ladi-vton-pipeline.git
git submodule update --init --recursive
```
You can either use the installation script 
```
cd ./auto-vton
bash install.sh
```
Or repeat every step yourself with CLI in case you want to do set any tool differently or when something doesn't work with the script, that I can see happening.

## Some comments
### Project structure
Every repository which is needed for processing the data is linked as a submodule.
[CIHP_PGN](https://github.com/umanema/CIHP_PGN.git), [detectron2](https://github.com/umanema/detectron2.git) are forks of original repos with some changes done accordingly to this [post](https://github.com/sangyun884/HR-VITON/issues/45)

Installation script assumes that the repository is cloned to
```
/home/username/repositories
```
If you want it to be in a different location you should change the scripts a little bit or do installation manually.

#### Openpose models
Occasionally openpose models could not be downloaded from original source as described [here](https://github.com/CMU-Perceptual-Computing-Lab/openpose/issues/1602). In that case you will get zero keypoints on the resulted picture in .ladi-vton/data/hd-viton/test/openpose_img/person/person_rendered.png and .ladi-vton/data/hd-viton/test/openpose_json/person_keypoints.json. For that reason there is a script that shoudl download all the models from GDrive.
```
cd ./auto-vton
bash install_openpose_models.sh
```
When openpose wasn't built because of that issue you can do
```
cd ./auto-vton
bash rebuild_openpose.sh
```
## Running
Put the photo of a model into
```
./auto-vton/input/person
```
Put the photo of a cloth into 
```
./auto-vton/input/cloth
```
Run 
```
cd ./auto-vton
bash auto-vton.sh
```
If everything runs smooth you should find the resulted picture here
```
./auto-vton/result
```

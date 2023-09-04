# ladi-vton-pipeline
The main purpose of the repository is to prepare preprocessing repositories you need to run [LaDI-VTON](https://github.com/miccunifi/ladi-vton.git) with custom input.

The pipeline is tested on Ubuntu 20.04 and 22.04 with cuda capable GPU. Important to note that some of the repositories used in this project won't work anywhere except linux. Also I'm not sure how all of it's going work withouth GPU support. Theoretically it can.

## Installation

Get the repository
```
mkdir repositories
cd ~/repositories
git clone https://github.com/umanema/ladi-vton-pipeline.git
```
Installation process is split into two steps
```
cd ./auto-vton/installation
#first you install all dependencies
bash install_dependencies.sh
#in case you are running lambdalabs instance you need to run another installation script
#bash install_dependencies_lambda.sh
#install repositories
bash install_repositories.sh
```

## Project structure
Every repository which is needed for processing the data is linked as a submodule.
[CIHP_PGN](https://github.com/umanema/CIHP_PGN.git), [detectron2](https://github.com/umanema/detectron2.git) are forks of original repos with some changes done accordingly to this [post](https://github.com/sangyun884/HR-VITON/issues/45)

Installation script assumes that the root repository is cloned to
`/home/username/repositories`

If you want it to put it to a different location you might need to change installation scripts a little bit or do installation manually.

## Running the auto-vton script

Put the photo of a model into
`./auto-vton/input/person`
Put the photo of a cloth into 
`./auto-vton/input/cloth`

Then run 
```
cd ./auto-vton
bash auto-vton.sh
```
If everything runs smoothly you should find the resulted picture in
`./auto-vton/result`

## Troubleshooting
### Openpose models bug
Occasionally openpose models could not be downloaded from original source as described [here](https://github.com/CMU-Perceptual-Computing-Lab/openpose/issues/1602). In that case openpose will not build or you will get zero keypoints on the resulted picture in .ladi-vton/data/hd-viton/test/openpose_img/person/person_rendered.png and .ladi-vton/data/hd-viton/test/openpose_json/person_keypoints.json. For that reason there is a script that should download all the models from GDrive.
```
cd ./auto-vton/installation/openpose
bash install_openpose_models.sh
#after that you need to rebuild the openpose
bash rebuild_openpose.sh
```


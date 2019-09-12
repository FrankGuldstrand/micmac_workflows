#!/bin/bash
export PATH=/home/buster/micmac7007/bin:$PATH #Location of MicMac Software

# Input and user preferences
IMG=".*.JPG" #Pattern of images to choose, in this case choose all.
DIR_INPUT="../input" # Directory where all the images are

[ -d output ] || mkdir output

# Prepare temporary working folder
mkdir tmp
cd tmp
cp $DIR_INPUT/* ./

# Calculate tie points
	mm3d Tapioca MulScale $IMG 500 -1 @SFS #Calculate image match and tie points

# Calculate internal and external distortion
	mm3d Tapas FraserBasic $IMG Out=G #ImInit="1.JPG" #Calculate camera orientation and distortion
	mm3d AperiCloud $IMG G Out="RelOri.ply" # Calculate lowres point cloud to check

# MEASURE GCPS

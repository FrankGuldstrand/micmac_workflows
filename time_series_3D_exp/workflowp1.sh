#!/bin/bash

# Set Path if needed
#export PATH=/home/buster/micmac7007/bin:$PATH

# Input and user preferences
BOX='[0.1,0.1,0.3,0.3]'
DIR="000"
DIR_INPUT="../input/$DIR"
DIR_OUTPUT="../output/$DIR"
IMG=".*.JPG"
IMGinit="1.JPG"
DIC="GCP.xml"
MES="Measure-S2D.xml"

ORT="1.JPG"
XML="MEC-Malt/NuageImProf_STD-MALT_Etape_9.xml"
TIF="Ortho-MEC-Malt/Ort_1.tif"

[ -d output ] || mkdir output

# Prepare temporary working folder
mkdir tmp
cd tmp
cp $DIR_INPUT/* ./

# Calculate tie points
mm3d Tapioca All $IMG -1 @SFS 

# Calculate internal and external distortion
mm3d Tapas FraserBasic $IMG Out=G ImInit="$IMGinit"

# Part 1 over now MEASURE GCPS

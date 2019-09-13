#!/bin/bash

#Linux
export PATH=/home/buster/micmac7007/bin:$PATH

#Mac
#export PATH=/Applications/micmacOLD/bin:$PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/micmacOLD/lib/
DIR="000"
DIR_INPUT="../input/$DIR"
mkdir tmp
cd tmp
cp $DIR_INPUT/* ./

cp -R ../GCP.xml GCP.xml

mm3d SaisieAppuisInitQT ".*.JPG" "NONE" GCP.xml Measure.xml


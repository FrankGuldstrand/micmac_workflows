#!/bin/bash

#Linux
#export PATH=/home/buster/micmac7007/bin:$PATH

#Mac
#export PATH=/Applications/micmacOLD/bin:$PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/micmacOLD/lib/
cd input

cp -R ../GCP.xml GCP.xml


mm3d SaisieAppuisInitQT "DSC_100[1-4].JPG" "Ori-G" GCP.xml Measure.xml


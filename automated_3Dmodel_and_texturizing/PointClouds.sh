#!/bin/bash
#export PATH=/home/buster/micmac7007/bin:$PATH

#Mac
#export PATH=/Applications/micmac/bin:$PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/micmac/lib/

# Input and user preferences


DIR_INPUT="../input/"
DIR_OUTPUT="../output/"
IMG=".*.JPG"

DIC="GCP.xml"
MES="Measure-S2D.xml"

ORT="DSC_0101.JPG"
XML="MEC-Malt/NuageImProf_STD-MALT_Etape_9.xml"
TIF="Ortho-MEC-Malt/Ort_DSC_0101.tif"

[ -d output ] || mkdir output

# Enter temporary working folder
cd input

# MEASURE GCPS

mm3d GCPBascule ".*.JPG" Ori-G TG $DIC $MES
mm3d Campari ".*.JPG" Ori-TG TGC GCP=[GCP.xml,0.02,Measure-S2D.xml,0.5]

# MAKE SPARSE POINT CLOUD

mm3d AperiCloud ".*.JPG" Ori-TGC Out=CAM2.ply

mm3d AperiCloud ".*.JPG" Ori-TGC WithCam=0 Out=Mask.ply










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

mm3d TiPunch C3DC.ply Out=IntMesh.ply Mode=Statue Pattern=".*.JPG" Depth=9
mm3d Tequila ".*.JPG" Ori-TGC IntMesh.ply #Mode=Basic 

## Collate output
#[ -d $DIR_OUTPUT ] || mkdir $DIR_OUTPUT
#mv Ortho-MEC-Malt/Ort_1.tif $DIR_OUTPUT/ORT.tif
#mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml $DIR_OUTPUT/DEM.xml
#mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.tif $DIR_OUTPUT/DEM.tif
#mv C3DC.ply $DIR_OUTPUT/C3DCCone.ply
#mv ConeMesh.ply $DIR_OUTPUT/ConeMesh.ply

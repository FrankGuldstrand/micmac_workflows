#!/bin/bash
export PATH=/home/buster/micmac/bin:$PATH

# Input and user preferences
DIR="1"
DIR_INPUT="../input/$DIR"
DIR_OUTPUT="../output/$DIR"
IMG=".*.TIF"
NrofIm="100"

DIC="GCP.xml"
MES="Measure-S2D.xml"

ORT="1.JPG"
XML="MEC-Malt/NuageImProf_STD-MALT_Etape_9.xml"
ZLIM="MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml"
ZLIMMASKTIF="MEC-Malt/Z_Num9_DeZoom1_STD-MALT_MasqZminmax.tif"
TIF="Ortho-MEC-Malt/Ort_1.tif"

[ -d output ] || mkdir output

for N in `seq 1 $NrofIm`; do
    
    Input and user preferences
    DIR="$(echo 00${N} | tail -c4)"
    IM1="$(echo 00${N} | tail -c4)"
    K=$((N+1))
    IM2="$(echo 00${K} | tail -c4)"
    DIR_INPUT="../input/$IM1.tif"
    DIR_INPUT2="../input/$IM2.tif"

    DIR_OUTPUT="../output/$DIR"

    echo $DIR
    echo $DIR_INPUT
    echo $DIR_OUTPUT

    # Prepare temporary working folder
    cd output
    mkdir $DIR
    cd ..

    mkdir tmp
    cd tmp
    cp $DIR_INPUT ./0.tif                 # Imagery
    cp $DIR_INPUT2 ./1.tif
    
    # Calculate displacement
    
    mm3d MM2DPosSism 0.tif 1.tif Reg=0.005 Inc=4.0 SzW=3
    
    # Collate output    
    mv MEC/Px1_Num6_DeZoom1_LeChantier.tif $DIR_OUTPUT/U_X.tif
    mv MEC/Px2_Num6_DeZoom1_LeChantier.tif $DIR_OUTPUT/U_Y.tif
    mv MEC/Z_Num6_DeZoom1_LeChantier.xml $DIR_OUTPUT/INF.xml        
    
    # Clear space and prepare next
    cd ..
    rm -R tmp
    DIR_PRE=$DIR_OUTPUT

done



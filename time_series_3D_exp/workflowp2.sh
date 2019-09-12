#!/bin/bash
export PATH=/home/buster/micmac/bin:$PATH

# Input and user preferences
BOX='[0.1,0.1,0.3,0.3]' 
DIR="000"
DIR_INPUT="../input/$DIR"
DIR_OUTPUT="../output/$DIR"
IMG=".*.JPG"
IMGinit="1.JPG"
DIC="GCP.xml"
MES="Measure-S2D.xml"
NrofIm="100"

ORT="1.JPG"
XML="MEC-Malt/NuageImProf_STD-MALT_Etape_9.xml"
ZLIM="MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml"
ZLIMMASKTIF="MEC-Malt/Z_Num9_DeZoom1_STD-MALT_MasqZminmax.tif"
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

# MEASURE GCPS

mm3d GCPBascule $IMG G TG $DIC $MES
mm3d Campari $IMG TG TGC GCP=[GCP.xml,0.2,Measure-S2D.xml,0.5]
mm3d AperiCloud $IMG TGC

# Calculate orthophoto, DEM and pointcloud
mm3d Malt Ortho $IMG TGC ZoomF=1 ImOrtho=$ORT BoxTerrain=$BOX Regul=0.005 SzW=3

mm3d Zlimit $ZLIM -0.20 0.20 #Masks point cloud from min to max range

mm3d Nuage2ply $XML Mask=$ZLIMMASKTIF Attr=$TIF 

# Collate output
[ -d $DIR_OUTPUT ] || mkdir $DIR_OUTPUT
mv Ortho-MEC-Malt/Ort_1.tif $DIR_OUTPUT/ORT.tif
mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml $DIR_OUTPUT/DEM.xml
mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.tif $DIR_OUTPUT/DEM.tif
mv MEC-Malt/NuageImProf_STD-MALT_Etape_9.ply $DIR_OUTPUT/ORT.ply
mv AperiCloud* $DIR_OUTPUT/CAM.ply
cp -R Ori-TGC $DIR_OUTPUT/Ori-TGC

# Clear space and prepare next
cd ..
rm -R tmp

DIR_PRE=$DIR_OUTPUT
DIR_INI=$DIR_PRE

### START OF LOOP

for N in `seq 1 $NrofIm`; do 
    
    Input and user preferences
    DIR="$(echo 00${N} | tail -c4)"
    DIR_INPUT="../input/$DIR"
    DIR_OUTPUT="../output/$DIR"
    
    echo $DIR
    echo $DIR_INPUT
    echo $DIR_OUTPUT

    # Prepare temporary working folder
    mkdir tmp
    cd tmp
    cp $DIR_INPUT/* ./                 # Imagery
    cp -R $DIR_INI/Ori-TGC ./          # Distortion model
    
    # Calculate orthophoto, DEM and pointcloud
    mm3d Malt Ortho $IMG TGC ZoomF=1 ImOrtho=$ORT BoxTerrain=$BOX Regul=0.005 SzW=3
    mm3d Zlimit $ZLIM -0.20 0.20 #Masks point cloud from min to max range

    mm3d Nuage2ply $XML Mask=$ZLIMMASKTIF Attr=$TIF 

    # Collate output
    [ -d $DIR_OUTPUT ] || mkdir $DIR_OUTPUT
    mv Ortho-MEC-Malt/Ort_1.tif $DIR_OUTPUT/ORT.tif
    mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml $DIR_OUTPUT/DEM.xml
    mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.tif $DIR_OUTPUT/DEM.tif
    mv MEC-Malt/NuageImProf_STD-MALT_Etape_9.ply $DIR_OUTPUT/ORT.ply
    
    # Calculate displacement
    cp $DIR_PRE/ORT.tif ORT1.tif
    cp $DIR_OUTPUT/ORT.tif ORT2.tif
    
    mm3d MM2DPosSism ORT1.tif ORT2.tif Reg=0.005 Inc=4.0
    
    # Collate output    
    mv MEC/Px1_Num6_DeZoom1_LeChantier.tif $DIR_OUTPUT/U_X.tif
    mv MEC/Px2_Num6_DeZoom1_LeChantier.tif $DIR_OUTPUT/U_Y.tif
    mv MEC/Z_Num6_DeZoom1_LeChantier.xml $DIR_OUTPUT/INF.xml 
        
    
    # Clear space and prepare next
    cd ..
    rm -R tmp
    DIR_PRE=$DIR_OUTPUT

done

exit 0


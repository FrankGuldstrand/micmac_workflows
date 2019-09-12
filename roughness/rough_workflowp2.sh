#!/bin/bash
export PATH=/home/buster/micmac/bin:$PATH

#### Input and user preferences

#### SET BOUNDING BOX (FROM GCPS) ####
BOX='[5,5,150,150]' # [mm]

#### CHOOSE DIGITAL ELEVATION MODEL RESOLUTION (9 HIGHEST )#####
DEMNUM="9" #Digital Elevation Model Step

#### VARIABLES
IMG=".*.JPG" # CHOOSE ALL IMAGES
DIC="GCP.xml" # FILE WITH GCP MEASUREMENTS
MES="Measure-S2D.xml" # GCPS MEASURED IN PHOTOS
XML="MEC-Malt/NuageImProf_STD-MALT_Etape_$DEMNUM.xml" # XML Nuage info for creating point cloud
ZLIM="MEC-Malt/Z_Num${DEMNUM}_DeZoom1_STD-MALT.xml" # Raw DEM scale info
ZLIMMASKTIF="MEC-Malt/Z_Num${DEMNUM}_DeZoom1_STD-MALT_MasqZminmax.tif" # MASKED DEM
TIF="Ortho-MEC-Malt/Orthophotomosaic.tif" # ORTHOPHOTO 

DIR_OUTPUT="../output/DEMSTEP_${DEMNUM}"

#### Enter temporary working folder
cd tmp

#### MEASURE GCPS

	mm3d GCPBascule $IMG G TG $DIC $MES # CONVERT Arbitrary to Absolute orientation G->TG
	mm3d Campari $IMG TG TGC GCP=[GCP.xml,0.5,Measure-S2D.xml,0.5] # Bundle Adjustment TG->TGC
	mm3d AperiCloud $IMG TGC Out="AbsOri.ply" # Quick PointCloud to Check Absolute Orientation

#### Calculate orthophoto, DEM and pointcloud
	mm3d Malt Ortho $IMG TGC ZoomF=1 BoxTerrain=$BOX Regul=0.005 SzW=2 #ImOrtho="DSC_0017.JPG"
	
	mm3d Tawny Ortho-MEC-Malt/ RadiomEgal=0 #Creates Orthophoto

	mm3d Zlimit $ZLIM -300 300
	#Masks point cloud from min to max vertical range
	#Optional arguments
	#[CorrelIm] to use correlation image as mask
	#[CorrelThr] set a correlation threshold for accceptance (def=0.02)

	mm3d Nuage2ply $XML Mask=$ZLIMMASKTIF Attr=$TIF Out=OrthoPointCloudMasked.ply # Masked Point Cloud
	mm3d Nuage2ply $XML Attr=$TIF Out=OrthoPointCloud.ply # Unmasked Point Cloud


#### Collate output [Copy outputs to directory output]
[ -d $DIR_OUTPUT ] || mkdir $DIR_OUTPUT

cp $TIF $DIR_OUTPUT/ORT.tif #Copy Orthophoto to Output

cp MEC-Malt/Z_Num${DEMNUM}_DeZoom1_STD-MALT.xml $DIR_OUTPUT/DEM.xml #Copy raw DEM scale info
cp MEC-Malt/Z_Num${DEMNUM}_DeZoom1_STD-MALT.tif $DIR_OUTPUT/DEM.tif #Copy raw DEM

cp MEC-Malt/Z_Num${DEMNUM}_DeZoom1_STD-MALT_Masked.xml $DIR_OUTPUT/DEM_masked.xml #Copy Masked DEM scale info
cp MEC-Malt/Z_Num${DEMNUM}_DeZoom1_STD-MALT_Masked.tif $DIR_OUTPUT/DEM_masked.tif #Copy Masked DEM

cp OrthoPointCloud.ply $DIR_OUTPUT/ORT_nonmasked.ply #Copy HighRes Pointcloud
cp OrthoPointCloudMasked.ply $DIR_OUTPUT/ORT_masked.ply #Copy HighRes Masked Pointcloud

#Copy quality information
cp AbsOri* $DIR_OUTPUT/CAM.ply #Copy test point cloud absolute Ori
cp -R Ori-TGC $DIR_OUTPUT/Ori-TGC #Copy distortion and orientation directory
cp MEC-Malt/Correl_STD-MALT_Num_8.tif $DIR_OUTPUT/CorrMap.tif #Copy correlation map



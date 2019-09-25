#!/bin/bash
export PATH=/home/buster/micmac/bin:$PATH

cd sill2

#Get the GNSS data out of the images and convert it to a txt file (GpsCoordinatesFromExif.txt)
mm3d XifGps2Txt .*JPG
#Get the GNSS data out of the images and convert it to a xml orientation folder (Ori-RAWGNSS), also create a good RTL (Local Radial Tangential) system.
mm3d XifGps2Xml .*JPG RAWGNSS
#Use the GpsCoordinatesFromExif.txt file to create a xml orientation folder (Ori-RAWGNSS_N), and a file (FileImagesNeighbour.xml) detailing what image sees what other image (if camera is <50m away with option DN=50)
mm3d OriConvert "#F=N X Y Z" GpsCoordinatesFromExif.txt RAWGNSS_N ChSys=DegreeWGS84@RTLFromExif.xml MTD1=1 NameCple=FileImagesNeighbour.xml DN=50
#Find Tie points using 1/2 resolution image (best value for RGB bayer sensor)
mm3d Tapioca File FileImagesNeighbour.xml 2000
#filter TiePoints (better distribution, avoid clogging)
mm3d Schnaps .*JPG
#Compute Relative orientation (Arbitrary system)
mm3d Tapas FraserBasic .*JPG Out=Arbitrary SH="_mini"
#Visualize relative orientation
mm3d AperiCloud .*JPG Ori-Arbitrary
#Transform to  RTL system
mm3d CenterBascule .*JPG Arbitrary RAWGNSS_N Ground_Init_RTL

#Bundle adjust using both camera positions and tie points (number in EmGPS option is the quality estimate of the GNSS data in meters)
mm3d Campari .*JPG Ground_Init_RTL Ground_RTL EmGPS=[RAWGNSS_N,5] AllFree=1 SH="_mini"

#Change system to final cartographic system
mm3d ChgSysCo  .*JPG Ground_RTL RTLFromExif.xml@SysCoUTM19S.xml Ground_UTM19S

### OPTION 1 C3DC
mm3d C3DC BigMac ".*.JPG" Ground_UTM19S Out=C3DC.ply ZoomF=2 #Masq3D=MaskClean.ply

### OPTION 2 MALT
#Correlation into DEM
#mm3d Malt Ortho ".*.JPG" Ground_UTM19S ResolTerrain=0.025
#Mosaic from individual orthos
#mm3d Tawny Ortho-MEC-Malt RadiomEgal=0
#PointCloud from Ortho+DEM, with offset substracted to the coordinates to solve the 32bit precision issue
#mm3d Nuage2Ply MEC-Malt/NuageImProf_STD-MALT_Etape_8.xml Attr=Ortho-MEC-Malt/Orthophotomosaic.tif Out=Malt.ply Offs=[430000,4570000,0]

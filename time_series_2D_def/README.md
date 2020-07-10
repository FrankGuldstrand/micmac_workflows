
NB! not nice code.

image_correction.m is used first on the images in folder "cam1". 

They are likely in landscape so first it rotates them before applying the image correction. 
This scripts needs to be manually run section by section and supervised.

The output of image_correction.m is then used as the input to MicMac MM2DPosSism using the bash shellscript.

Load_and_process_data.m is then run on the output images (U_x.tif and U_y.tif) from MicMac MM2DPosSism.

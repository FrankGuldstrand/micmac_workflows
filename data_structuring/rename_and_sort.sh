#!/bin/bash
# Rewrite as fitting

m=-1;
for i in cam1/*.JPG; do                     # images (time sort) in folder cam#
    let m=m+1                               # counter
    mkdir `printf %03d $(echo $m)`          # make timestep folder
    cp $i `printf %03d/1.JPG $(echo $m)`    # copy image per timestep into 
                                            # timestep folder, rename with cam#
done

m=-1;
for i in cam2/*.JPG; do 
    let m=m+1
    cp $i `printf %03d/2.JPG $(echo $m)`
done

m=-1;
for i in cam3/*.JPG; do 
    let m=m+1
    cp $i `printf %03d/3.JPG $(echo $m)`
done

m=-1;
for i in cam4/*.JPG; do 
    let m=m+1
    cp $i `printf %03d/4.JPG $(echo $m)`
done

exit 0

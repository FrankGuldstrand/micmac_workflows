#!/bin/bash
#export PATH=/home/buster/micmac6550/bin:$PATH
#export PATH=/home/buster/micmac7007/bin:$PATH
#Mac
#export PATH=/Applications/micmac/bin:$PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/micmac/lib/

# Input and user preferences

# Prepare temporary working folder
cd input


mm3d SaisieMasqQT "MaskClean.ply"

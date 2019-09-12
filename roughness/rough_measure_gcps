#!/bin/bash

export PATH=/home/buster/micmac7007/bin:$PATH # Location of MicMac

cd tmp #Enter temperary working dir

cp -R ../GCP.xml GCP.xml #Copy xml containing Ground Control Point (GCP) info from directory above.

mm3d SaisieAppuisInitQT ".*.JPG" "Ori-G" GCP.xml Measure.xml #Start micmac GCP picking GUI.

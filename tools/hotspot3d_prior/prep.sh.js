'#!/bin/bash \n\
\n\
mkdir proximityFiles \n\
mkdir proximityFiles/inProgress \n\
mkdir proximityFiles/pdbCoordinateFiles \n\
mkdir proximityFiles/cosmicanno \n\
cp '+$job.inputs.cosmic_annotated_proximity_file.path+' proximityFiles/cosmicanno';


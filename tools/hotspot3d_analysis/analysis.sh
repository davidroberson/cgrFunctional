
/opt/hotspot3d/bin/hotspot3d search --maf-file demo.maf --prep-dir ./

/opt/hotspot3d/bin/hotspot3d post --maf-file=demo.maf 

/opt/hotspot3d/bin/hotspot3d cluster --collapsed-file=3D_Proximity.pairwise.singleprotein.collapsed --pairwise-file=3D_Proximity.pairwise --maf-file demo.maf

#/opt/hotspot3d/bin/hotspot3d sigclus --prep-dir=./ --pairwise-file 3D_Proximity.pairwise --clusters-file 3D_Proximity.pairwise.singleprotein.collapsed

/opt/hotspot3d/bin/hotspot3d summary --clusters-file=3D_Proximity.pairwise.singleprotein.collapsed.clusters

/opt/hotspot3d/bin/hotspot3d visual --pairwise-file=3D_Proximity.pairwise --clusters-file=3D_Proximity.pairwise.singleprotein.collapsed.clusters --pdb=3XSR


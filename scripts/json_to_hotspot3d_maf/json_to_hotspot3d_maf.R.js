'# basic packages \n\
require(tidyverse) \n\
# get args \n\
args_json = data_frame(path = "'+$job.inputs.json.path+'") \n\
source("json_to_hotspot3d_maf.main.R")';

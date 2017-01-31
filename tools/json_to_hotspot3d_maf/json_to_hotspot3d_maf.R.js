'# basic packages \n\
require(tidyverse) \n\
# get args \n\
args_solvebio_api_key = '+$job.inputs.solvebio_api_token+' \n\
args_dataset = '+$job.inputs.dataset+' \n\
args_filters = '+$job.inputs.filters+' \n\
args_query = '+$job.inputs.query+' \n\
args_maf_out_prefix = '+$job.inputs.maf_out_prefix+' \n\
source("json_to_hotspot3d_maf.main.R")';

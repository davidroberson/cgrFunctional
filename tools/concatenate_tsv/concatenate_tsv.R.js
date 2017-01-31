var tsv_path = $job.inputs.tsv_files.map(function(elem){
  return elem.path}).join('", "');

var tsv_sample_id = $job.inputs.tsv_files.map(function(elem){
  return elem.metadata.sample_id}).join('", "');


'# load packages \n\
require(tidyverse); require(jsonlite); \n\
# get args \n\
args_tsv = data_frame(\n\
path = c("'+tsv_path+'"), \n\
sample_id = c("'+tsv_sample_id+'")) \n\
source("concatenate_tsv.main.R")';

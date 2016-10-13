require(tidyverse); require(jsonlite);

args = data_frame(prefixAndValue = commandArgs(TRUE)) %>% separate(prefixAndValue, into = c("prefix", "value"), "=")

json = stream_in(file(filter(args, prefix == "--json")$value), pagesize = 1000)

output <- file("temp_unnest.json", open = "wb")
json_df = stream_in(file("small.json"), pagesize=1, handler=
function(df){
temp = flatten(df) 
cat("\nLength of df ", length(temp), "rows\n")

temp_unnest = temp %>% 
select(info.ANN) %>% 
unnest(info.ANN) %>% 
mutate(ANN_number = 1:length(Distance)) %>% 
group_by(ANN_number) %>%
do(bind_cols(temp, .)) %>% 
ungroup()

stream_out(temp_unnest, output)})
close(output)
json_df = as_tibble(stream_in(file("temp_unnest.json")))



json_df_2 = json_df %>% 
unnest(info.UCSC_KnownGene_Exomic_Variant_Detail)





temp = args_tsv %>% 
group_by(path) %>% 
do(read_tsv(.$path,col_types=cols(Chromosome = "c"))) %>% 
ungroup() %>% 
select(-path) %>% 
filter(amino_acid_change != "No_record")

write_tsv(temp, paste0(args_tsv$sample_id[1], ".maf"))

output = file(paste0(args_tsv$sample_id[1], ".maf.json"), open = "wb")

stream_out(temp, output)

close(output)

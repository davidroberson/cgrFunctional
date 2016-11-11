require(tidyverse); require(jsonlite);
#Tumor_Sample_Barcode args_json$sample_id

output = file("maf.json", open = "wb")

json_df = stream_in(file(args_json$path), pagesize=1, handler=
function(df){

temp = flatten(df, recursive=TRUE)

temp_unnest = temp %>%
select(info.ANN) %>%
unnest(info.ANN) %>%
mutate(ANN_number = 1:length(Distance)) %>% 
mutate(sample_id = "sample_A") %>% 
group_by(ANN_number) %>%
do(bind_cols(temp, .)) %>%
ungroup() %>%
mutate(Tumor_Sample_Barcode = "Sample_A") %>% 
select(
Hugo_Symbol = Gene_Name,
Chromosome = genomic_coordinates.chromosome,
Start_Position = genomic_coordinates.start,
End_Position = genomic_coordinates.stop,
Variant_Classification = Annotation,
Reference_Allele = reference_allele,
Tumor_Seq_Allele1 = allele,
Tumor_Seq_Allele2 = allele,
Tumor_Sample_Barcode,
transcript_name = Feature_ID,
amino_acid_change = HGVS_c) %>% 
unnest()

stream_out(temp_unnest, output)})

close(output)

maf = stream_in(file("maf.json"))

write_tsv(maf, "sample_set.maf")

save.image("json_to_hotspot3d_maf.Rda")

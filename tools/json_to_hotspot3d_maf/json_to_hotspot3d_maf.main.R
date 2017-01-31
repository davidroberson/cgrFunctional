
# load packages ----
require(tidyverse); require(stringi); require(V8); require(solvebio); require(jsonlite);

# solvebio login ----
login(api_key = args_solvebio_api_key)

# js object ----
js = v8()

# solvebio api calls ----
output = file("maf.json", open = "wb")
maf = DepositoryVersion.datasets(args_dataset)$data %>%
select(-metadata) %>%
filter(stri_sub(name, 1,3) == "DC_") %>%
group_by(full_name, name) %>%
do(Dataset.query(.$full_name, filters=args_filters, query=args_query, limit=10000, paginate=TRUE)) %>%
ungroup()  %>%
select(-full_name, -`_id`, -`_commit`) %>%
mutate(Tumor_Seq_Allele1 = allele) %>%
mutate(Tumor_Seq_Allele2 = allele) %>%
select(Hugo_Symbol = info.Ensembl_GeneName, variant, Reference_Allele = reference_allele,
Tumor_Seq_Allele1, Tumor_Seq_Allele2, Tumor_Sample_Barcode =  name, info.refGene_Exomic_Variant_Detail, alternate_alleles,
info.refGene_Gene_And_Region, info.refGene_Exomic_Variant_Category, info.ANN) %>%
mutate(num = 1:length(variant)) %>%
group_by(num) %>%
do({
temp = .
temp_unnest = temp %>%
mutate(Hugo_Symbol_char = as.character(.$Hugo_Symbol)) %>%
mutate(alternate_alleles_char = as.character(alternate_alleles)) %>%
mutate(info.refGene_Gene_And_Region_char = as.character(info.refGene_Gene_And_Region)) %>%
mutate(info.refGene_Exomic_Variant_Category_char = as.character(info.refGene_Exomic_Variant_Category)) %>%
ungroup() %>%
do(bind_cols(temp, .)) %>%
ungroup()
}) %>%
filter(info.refGene_Exomic_Variant_Detail != "NULL") %>%
ungroup() %>%
select(-Hugo_Symbol,
  -alternate_alleles,
  -info.refGene_Gene_And_Region,
  -info.refGene_Exomic_Variant_Category) %>%
select(Hugo_Symbol = Hugo_Symbol_char,
alternate_alleles = alternate_alleles_char,
info.refGene_Gene_And_Region = info.refGene_Gene_And_Region_char,
info.refGene_Exomic_Variant_Category = info.refGene_Exomic_Variant_Category_char, 1:12)

output = file("maf.json", open = "wb"); stream_out(maf, output); close(output)

# unnest ANN ----
output = file("maf_ann.json", open = "wb")
json_df = stream_in(file("maf.json"), pagesize=1,
handler= function(df){
temp = as_tibble(df)
temp_unnest = temp %>%
select(info.ANN) %>%
unnest(info.ANN) %>%
mutate(ANN_number = 1:n()) %>%
group_by(ANN_number) %>%
do(bind_cols(temp, .)) %>%
ungroup()
stream_out(temp_unnest, output)})
close(output)

# final unnest ----
maf_detail = stream_in(file("maf_ann.json")) %>%
ungroup() %>%
unnest(info.refGene_Exomic_Variant_Detail) %>%
filter(info.refGene_Exomic_Variant_Detail != "") %>%
as_tibble() %>%
rowwise() %>%
mutate(amino_acid_change = js$eval(paste0('"',info.refGene_Exomic_Variant_Detail,'".split(":")[4]'))) %>%
mutate(Chromosome = js$eval(paste0('"',variant,'".split("-")[1].split("CHR")[1]'))) %>%
mutate(Start_Position = js$eval(paste0('"',variant,'".split("-")[2]'))) %>%
mutate(End_Position = js$eval(paste0('"',variant,'".split("-")[3]'))) %>%
ungroup() %>%
select(Hugo_Symbol, Chromosome, Start_Position,
  End_Position, Variant_Classification = info.refGene_Exomic_Variant_Category,
  Reference_Allele, Tumor_Seq_Allele1, Tumor_Seq_Allele2,
  Tumor_Sample_Barcode, transcript_name = Feature_ID, amino_acid_change) %>%
arrange(Hugo_Symbol, Chromosome, Start_Position, Tumor_Sample_Barcode) %>%
distinct()

# output = file("maf_large_set.json", open = "wb"); stream_out(maf_detail, output); close(output)
# system("gzip maf_large_set.json")

write_tsv(maf_detail, paste0(args_maf_out_prefix, "_hotspot3d.maf.tsv"))

Concatenate TSV Tool
================

-   [Description](#description)
-   [base command](#base-command)
-   [i/o](#io)
    -   [inputs](#inputs)
    -   [outputs](#outputs)
    -   [add on scripts](#add-on-scripts)
-   [Containerization](#containerization)
    -   [Docker](#docker)
    -   [tool definition](#tool-definition)
    -   [cwl file](#cwl-file)
    -   [push app to cloud platform](#push-app-to-cloud-platform)

Description
-----------

Utility to concatenate tsv files and keep the header where it belongs (at the top).

base command
------------

``` sh

Rscript concatenate_tsv.R --tsv_files=
```

i/o
---

### inputs

``` r
inputs = list(
  
input(id = "tsv_files", label = "tsv_files", description = "tsv_files", type = "File...", prefix = "--tsv_files=")
  
)
```

### outputs

``` r
outputs = list(

output(id = "std_out", label = "std_out", 
description = "standard output", type = "File",
metadata = list(from_tool = "merge_tsv"),
glob = '"std.out"'),
  
output(id = "merged_tsv", label = "merged_tsv", 
description = "merged_tsv", type = "File",
inheritMetadataFrom = "#tsv_files", metadata = list(from_tool = "merge_tsv"),
glob = Expression(engine = "#cwl-js-engine",
script = '"*.merged.tsv"'))
  
)
```

### add on scripts

``` r
concatenate_tsv_main_R = fileDef(name = "concatenate_tsv.main.R", content = read_file("concatenate_tsv.main.R"))

concatenate_tsv_R = fileDef(name = "concatenate_tsv.R.js", content = read_file("concatenate_tsv.R.js"))
```

Containerization
----------------

### Docker

The docker conatiner is

`cgrlab/tidyverse:latest`

### tool definition

``` r
tool <- Tool(
id = "concatenate_tsv", 
label = "concatenate_tsv",
hints = requirements(docker(pull = "cgrlab/tidyverse:latest"), cpu(1), mem(1000)),

requirements = requirements(concatenate_tsv_main_R, concatenate_tsv_R),
  
  baseCommand = "Rscript concatenate_tsv.R",

stdout = "std.out",

inputs = inputs,
  
outputs = outputs)
```

### cwl file

``` r
write(tool$toJSON(pretty = TRUE), "./Rmd.cwl.json")
```

### push app to cloud platform

``` r
project$app_add("concatenate_tsv", tool)
```

JSON to Hotspot3d MAF
================

-   [Description](#description)
-   [base command](#base-command)
-   [i/o](#io)
    -   [inputs](#inputs)
    -   [arguments](#arguments)
    -   [outputs](#outputs)
    -   [add on scripts](#add-on-scripts)
-   [Containerization](#containerization)
    -   [Docker](#docker)
    -   [tool definition](#tool-definition)
    -   [cwl file](#cwl-file)
    -   [push app to cloud platform](#push-app-to-cloud-platform)
    -   [notes](#notes)

Description
-----------

Utility to create a maf from json that is compatible with hotspot3d

<https://igor.sbgenomics.com/u/dave/cgrfunctional/apps/#dave/cgrfunctional/json-to-hotspot3d-maf/> (restricted)

base command
------------

``` sh

json2maf.R --json [json file to convert to maf] 
```

i/o
---

### inputs

``` r
inputs = list(
  
input(id = "json", label = "json", description = "a json created from an annotated vcf", type = "File", prefix = "--json=")
  
)
```

### arguments

``` r
arguments = CCBList(
CommandLineBinding(position = 99, valueFrom = list('"&& ls -lR"'))
)
```

### outputs

``` r
outputs = list(

output(id = "std_out", label = "std_out", 
description = "standard output", type = "File",
metadata = list(org = "cgp"),
glob = '"std.out"'),
  
output(id = "maf", label = "maf", 
description = "maf file created", type = "File",
inheritMetadataFrom = "#normal_bam", metadata = list(from_tool = "json"),
glob = Expression(engine = "#cwl-js-engine",
script = '"*.maf"'))
  
)
```

### add on scripts

``` r
json_to_hotspot3d_maf_R = fileDef(name = "json_to_hotspot3d_maf.main.R", content = read_file("json_to_hotspot3d_maf.main.R"))
```

Containerization
----------------

### Docker

The docker conatiner is

`cgrlab/tidyverse:latest`

### tool definition

``` r
tool <- Tool(
id = "json_to_hotspot3d_maf", 
label = "json_to_hotspot3d_maf",
hints = requirements(docker(pull = "cgrlab/tidyverse:latest"), cpu(1), mem(1000)),

baseCommand = "CPU=`grep -c ^processor /proc/cpuinfo` && ascat.pl -c $CPU -rs Human -ra NCBI37 -pr WGS -pl ILLUMINA -sg ascat_SnpGcCorrections.tsv -q 20 -g L -o ascat_output",

stdout = "std.out",

inputs = inputs,
  
arguments = arguments,
  
outputs = outputs)
```

### cwl file

``` r
write(tool$toJSON(pretty = TRUE), "../cwl.json")
```

### push app to cloud platform

``` r
project$app_add("json_to_hotspot3d_maf", tool)
```

### notes

Very important R package "jsonlite"

<http://jeroenooms.github.io/mongo-slides/#19>

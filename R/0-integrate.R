print("===========================")
print("Preprocess: Integrate")
print("===========================")
suppressPackageStartupMessages(library(tidyverse))
source("R/utils.R")
source("R/const.R")

output_dir <- file.path(OUT_DIR, "ngf-all")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Load Datasets --------------------
# Load NGF2 Experiments
file_name <- file.path(RAWDATA_DIR, "ngf2", "count-matrix.csv")
ngf2_data <- read_csv(file_name, show_col_types = FALSE)
file_name <- file.path(RAWDATA_DIR, "ngf2", "design-table.csv")
ngf2_coldata <- load_coldata(file_name)

# Load NGF3 Experiments
file_name <- file.path(RAWDATA_DIR, "ngf3", "count-matrix.csv")
ngf3_data <- read_csv(file_name, show_col_types = FALSE)
file_name <- file.path(RAWDATA_DIR, "ngf3", "design-table.csv")
ngf3_coldata <- load_coldata(file_name)

# Load NGF4 Experiments
file_name <- file.path(RAWDATA_DIR, "ngf4", "count-matrix.csv")
ngf4_data <- read_csv(file_name, show_col_types = FALSE)
file_name <- file.path(RAWDATA_DIR, "ngf4", "design-table.csv")
ngf4_coldata <- load_coldata(file_name)

# Process Datasets --------------------
# Merge Count Matrix
print(paste0("dim(ngf2_data): ", toString(dim(ngf2_data)))) # 17308    76
print(paste0("dim(ngf3_data): ", toString(dim(ngf3_data)))) # 17308    41
print(paste0("dim(ngf4_data): ", toString(dim(ngf4_data)))) # 17308    76

ngf_all_data <- ngf2_data %>% left_join(ngf3_data) %>% left_join(ngf4_data)
print(paste0("dim(ngf_all_data): ", toString(dim(ngf_all_data)))) # 17308    191

# Merge Design Table
ngf2_coldata["Batch"] <- paste0("ngf2-", ngf2_coldata[["Batch"]])
ngf2_coldata["Dataset"] <- rep("ngf2", dim(ngf2_coldata)[1])

ngf3_coldata["Batch"] <- paste0("ngf3-", ngf3_coldata[["Batch"]])
ngf3_coldata["Dataset"] <- rep("ngf3", dim(ngf3_coldata)[1])

ngf4_coldata["Batch"] <- paste0("ngf4-", ngf4_coldata[["Batch"]])
ngf4_coldata["Dataset"] <- rep("ngf4", dim(ngf4_coldata)[1])

ngf_all_coldata <- do.call("rbind", 
                           list(ngf2_coldata, ngf3_coldata, ngf4_coldata))

dim(ngf_all_coldata) # 190   5

# Export Data --------------------
output_file <- file.path(output_dir, "count-matrix.csv")
write_csv(ngf_all_data, 
          output_file)

output_file <- file.path(output_dir, "design-table.csv")
write.csv(ngf_all_coldata,
          output_file, quote = FALSE, row.names = FALSE)

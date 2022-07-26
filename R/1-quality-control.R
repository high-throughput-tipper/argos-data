print("===========================")
print("Preprocess: Quality Control")
print("===========================")
library("cowplot")
source("R/utils.R")
source("R/const.R")

output_dir <- file.path(OUT_DIR, "ngf-all-qc")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Read Data ----------
file_name <- file.path(OUT_DIR, "ngf-all", "count-matrix.csv")
ngf_data <- load_dataset(file_name)
file_name <- file.path(OUT_DIR, "ngf-all", "design-table.csv")
my_coldata <- load_coldata(file_name)

res <- preprocess_rawdata(ngf_data, my_coldata, TRUE)
the_data <- res$rawData
col_data <- res$colData
print(paste0("dim(the_data): ", toString(dim(the_data)))) # 17308   163
print(paste0("dim(col_data): ", toString(dim(col_data)))) # 163   5

# Export Data --------------------
output_file <- file.path(output_dir, "count-matrix.csv")
write.csv(the_data, output_file, quote = FALSE)
output_file <- file.path(output_dir, "design-table.csv")
write.csv(col_data,
          output_file, quote = FALSE, row.names = FALSE)

res_plot <- ggplot(col_data, aes(x = Group)) +
    geom_bar(position = "stack", aes(fill = Dataset))
output_file <- file.path(output_dir, "qc-barplot.png")
save_plot(output_file, res_plot, ncol = 0.7, nrow = 0.7)

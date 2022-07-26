print("===========================")
print("Preprocess: Normalization")
print("===========================")
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(DESeq2))
suppressPackageStartupMessages(library(SingleCellExperiment))
suppressPackageStartupMessages(library(scran))
source("R/utils.R")
source("R/const.R")

# Set up environments ----------

# Handlers ----------
normalize_data <- function(data_path) {
  file_name <- file.path(data_path, "count-matrix.csv")
  ngf_data <- read.csv(file_name, row.names = 1)
  
  file_name <- file.path(data_path, "design-table.csv")
  col_data <- read.csv(file_name, row.names = 1)
  rownames(col_data) <- str_replace_all(rownames(col_data), "-", ".")
  col_data$Batch <- str_replace_all(col_data$Batch, "-", ".")
  
  col_data$Group <- as.factor(col_data$Group)
  col_data$Batch <- as.factor(col_data$Batch)
  col_data$Annotation <- as.factor(col_data$Annotation)
  col_data$Dataset <- as.factor(col_data$Dataset)
  
  sce <- DESeqDataSetFromMatrix(countData = ngf_data,
                                colData = col_data,
                                design = ~Batch + Group)
  
  # Normalization: Library size ----------
  sce <- logNormCounts(sce, log=TRUE,
                       name="log.lib.size",
                       size.factors=librarySizeFactors(sce))
  
  sce <- logNormCounts(sce, log=FALSE,
                       name="lib.size",
                       size.factors=librarySizeFactors(sce))
  
  # Normalization: Deconvolution ----------
  sce <- logNormCounts(sce, log=TRUE,
                       name="log.deconv", 
                       size.factors=pooledSizeFactors(sce))
  
  sce <- logNormCounts(sce, log=FALSE,
                       name="deconv", 
                       size.factors=pooledSizeFactors(sce))
  ngf_data_norm <- assay(sce, "log.lib.size")
  ngf_data_norm_df <- data.frame(ngf_data_norm)
  file_name <- file.path(data_path, "count-matrix-norm-log.lib.size.csv")
  ngf_data_norm_df["symbol"] <- row.names(ngf_data_norm)
  ngf_data_norm_df <- select(ngf_data_norm_df, symbol, everything())
  write_csv(ngf_data_norm_df, file_name)
  
  ngf_data_norm_df <- data.frame(assay(sce, "lib.size"))
  file_name <- file.path(data_path, "count-matrix-norm-lib.size.csv")
  ngf_data_norm_df["symbol"] <- row.names(ngf_data_norm)
  ngf_data_norm_df <- select(ngf_data_norm_df, symbol, everything())
  write_csv(ngf_data_norm_df, file_name)
  
  ngf_data_norm_df <- data.frame(assay(sce, "log.deconv"))
  file_name <- file.path(data_path, "count-matrix-norm-lib.log.deconv.csv")
  ngf_data_norm_df["symbol"] <- row.names(ngf_data_norm)
  ngf_data_norm_df <- select(ngf_data_norm_df, symbol, everything())
  write_csv(ngf_data_norm_df, file_name)
  
  ngf_data_norm_df <- data.frame(assay(sce, "deconv"))
  file_name <- file.path(data_path, "count-matrix-norm-lib.deconv.csv")
  ngf_data_norm_df["symbol"] <- row.names(ngf_data_norm)
  ngf_data_norm_df <- select(ngf_data_norm_df, symbol, everything())
  write_csv(ngf_data_norm_df, file_name)
}

normalize_data(file.path("out", "ngf-all-qc"))

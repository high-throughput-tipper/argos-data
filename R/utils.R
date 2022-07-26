suppressPackageStartupMessages(library(tidyverse))

create_outputdir <- function(run_time, stage_name, showWarnings = FALSE){
  # Create the runtime directory and the stage-specific directory
  runtime_dir <- file.path("out", paste0("runtime-", run_time))
  out_dir <- file.path("out", paste0("runtime-", run_time), stage_name)
  dir.create(out_dir, showWarnings = showWarnings, recursive = TRUE)
  list(runtime_dir, out_dir)
}


load_dataset <- function(input_path) {
  my_df <- as.data.frame(read_csv(input_path, show_col_types = FALSE))
  rownames(my_df) <- my_df$symbol
  my_df[, -1]
}

load_coldata <- function(input_path) {
  read_csv(input_path, show_col_types = FALSE)
}

preprocess_rawdata <- function(raw_matrix, design_table, select_flg) {
  res_list <- list("rawData" = raw_matrix, "colData" = design_table)

  if (select_flg) {
    res_list$colData <-
      design_table %>% filter((Group == "C" & Annotation == "N") |
                                Group %in% c("2", "3", "7") &
                                  Annotation == "Y" |
                                Group %in% "1" &
                                  Annotation != "O")
    col_idx <- res_list$colData$Sample
    res_list$rawData <- res_list$rawData[, col_idx]
  }
  res_list
}

my_write <- function(wrt_flg, my_file_name, my_table) {
  if (wrt_flg) {
    file_name <- my_file_name
    if (!file.exists(file_name)) {
      cat("writing to :", file_name, "\n")
      write_csv(my_table, my_file_name)
    }else {
      cat("File exists :", file_name, "\n")
    }
  }
}

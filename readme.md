# Argos Dataset Repostiory

This dataset is used to generate the transcriptomics dataset used in Argos `Data Exploration`, `Time Series Inspection`, and `recipe calculator` modules. The scRNA-seq data is processed by quality control and Normalization.

For quality control, we annotated cells by images with Y(Neural like), N (Not-neural-like), O(outliers).

- For cells in `control` group, `N` cells are selected.
- For cells in `day-2`, `day-3`, and `day-7` groups, `Y` cells are selected.
- For cells in `day-1` groups, both `N` cells and `Y` cells are selected.

Based on [DeSeq2 documentation](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#recommendations-for-single-cell-analysis), `scran::computeSumFactors` is used for normalization.

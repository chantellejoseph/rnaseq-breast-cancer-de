#Bioconductor Packages

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c(
  "TCGAbiolinks",
  "DESeq2",
  "SummarizedExperiment",
  "clusterProfiler",
  "org.Hs.eg.db",
  "EnhancedVolcano",
  "pheatmap",
  "ComplexHeatmap"
))

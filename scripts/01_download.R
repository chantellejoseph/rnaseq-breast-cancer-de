library(TCGAbiolinks)
library(SummarizedExperiment)
library(dplyr)

#1. Query TCGA-BRCA RNA-seq raw counts (STAR - Counts)
query <- GDCquery(
  project = "TCGA-BRCA",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts"
  )

GDCdownload(query, directory = "data/GDCdata")
data <- GDCprepare(query, directory = "data/GDCdata")

#2. Identify sample types (Tumor = 01 and Normal = 11, from barcode)
sample_types <- substr(colnames(data), 14, 15)
table(sample_types)

#3. Keep only patients with both a tumour and normal sample
patient_ids <- substr(colnames(data), 1, 12)
paired_patients <- patient_ids[sample_types == "01"][
  patient_ids[sample_types == "01"] %in% patient_ids[sample_types == "11"]
]
paired_patients <- unique(paired_patients)

keep <- patient_ids %in% paired_patients & sample_types %in% c("01", "11")
data_paired <- data[, keep]

# Save the SummarizedExperiment for downstream use
saveRDS(data_paired, "data/tcga_brca_paired.rds")

cat("Patients with paired samples:", length(paired_patients), "\n")
cat("Total samples kept:", ncol(data_paired), "\n")

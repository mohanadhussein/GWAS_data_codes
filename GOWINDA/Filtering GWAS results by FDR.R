setwd("C:/Users/MH/Desktop/EPFL/lab/GWAS/GWAS round 3/New conception/Vol")

library(data.table) #fread is actually in data.table
library(tidyverse)
tsv= read_tsv("absvol_Fcand_SNPs.tsv")
newtsv= "absvol_Fsubcand_SNPs.tsv"

tsvread= fread("absvol_Fcand_SNPs.tsv")
filtered= tsvread[FDR_BH<0.05]
fwrite(filtered,newtsv,sep= "\t", quote=FALSE)
nrow(filtered)
max(filtered$FDR_BH)
min(filtered$FDR_BH)



setwd("C:/Users/MH/Desktop/EPFL/lab/GWAS/post-return work/rrvgo")

# install.packages("readxl")
# install.packages("dplyr")
# install.packages("openxlsx")
library(readxl)
library(dplyr)
library(openxlsx)

# Read the Excel file
df <- read.csv("reducedTerms M.csv")

# Filtering GO terms based on keywords of relevance
# paste joins keyword to make a regex patter to match for, grepl matches it to df$terms 
keywords <- c("neuron", "projection", "cell","proliferation","mushroom")
filtered_data <- df %>%
  filter(grepl(paste(keywords, collapse = "|"), term, ignore.case = TRUE) & size > 0)

if (nrow(filtered_data)>0) {
  output_file="reducedTerms M_filtered.csv"
  write.csv(filtered_data, file=output_file, row.names=F)
  cat("Filtered data is copied to", output_file,"\n")
} else{
  cat("No matches")
}

#####
#reading functionassociate file
func_file= "funcassociate_go_associations.txt"
df_func <- read.delim(func_file, header=FALSE, comment.char="#")

#reading GWAS.vcf result file
gwas_res= read.delim("C:/Users/MH/Desktop/EPFL/lab/GWAS/post-return work/Abs_vol_M_cand_SNPS.vcf", header=FALSE, comment.char="#")

#####
#formatting gene names from columnV9 in Gwas results 
gene_pattern <- "FBgn\\d{7}"
gene_matches <- gregexpr(gene_pattern, gwas_res$V9)
gene_names <- regmatches(gwas_res$V9, gene_matches)
# Handle rows with no genes (assign NA)
gene_names[sapply(gene_names, length) == 0] <- NA
# Collapse genes into single strings, separated by spaces
gwas_res$Genes <- sapply(gene_names, function(x) paste(x, collapse = " "))

#inputting GO term
query_term="GO:0030182"


#####
#Function to find genes in gwas_results based on GO term
find_genes_from_GO <- function(query_term, df_func, gwas_res) {
  # Check if the GO term exists in df_func
  if (query_term %in% df_func$V1) {
    # Extract genes corresponding to GO term
    genes_for_go <- unlist(strsplit(as.character(df_func[df_func$V1 == query_term, "V3"]), "\\s+"))
  
    # Check for matching genes in gwas_res, ignoring case and applying p-value threshold
    matching_rows <- gwas_res[grepl(paste(genes_for_go, collapse = "|"), gwas_res$Genes, ignore.case = TRUE) & gwas_res$V8 < 0.1, ]
    
    # Create the output DataFrame
    if (nrow(matching_rows) > 0) {
      return(matching_rows[, c("V2", "V8", "Genes")])
    } else {
      return(NULL)  # Return NULL if no matches found
    }
  } else {
    return(NULL)  # Return NULL if GO term not found
  }
}

#saving results
result <- find_genes_from_GO(query_term, df_func, gwas_res)
#printing out results
if (!is.null(result)) {
  print(result)  # Print the results if matches were found
} else {
  print("No matching genes found.")
}
#outputtting results into .txt file,gsub replaces the : with _ due to function limitation
write.table(result, file = gsub(":", "_", paste0(query_term, ".txt")), row.names = FALSE, sep = "\t")

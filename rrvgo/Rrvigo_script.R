setwd("C:/Users/MH/Desktop/EPFL/lab/GWAS/post-return work")

getwd()

install.packages("vctrs")
install.packages("shinydashboard")
install.packages("htmltools")
update.packages("htmltools")
install.packages("DT")
BiocManager::install("shinydashboard")
BiocManager::install("org.Dm.eg.db")
BiocManager::install("rrvgo")
library(htmltools)
library(plotly)
library(shinydashboard)
library(org.Dm.eg.db)
library(BiocManager)
library(rrvgo)
library(DT)
library(vctrs)
library(heatmaply)
sessionInfo()

go_analysis <- read.delim("results_Abs_Vol_gene_basic_formated.txt")
simMatrix <- calculateSimMatrix(go_analysis$GeneGroup,
                                orgdb="org.Dm.eg.db",
                                ont="BP",
                                method="Rel")

scores <- setNames(-log10(go_analysis$pValues), go_analysis$ID)
reducedTerms <- reduceSimMatrix(simMatrix,
                                scores,
                                threshold=0.7,
                                orgdb="org.Dm.eg.db")

heatmapPlot(simMatrix, 
            annotateParent = TRUE,
            annotationLabel = "parentTerm",
            fontsize=6)

scatterPlot(simMatrix, reducedTerms)

treemapPlot(reducedTerms)

wordcloudPlot(reducedTerms, min.freq=1, colors="black")

rrvgo::shiny_rrvgo()
#i was in the step of removing the package manually from its path by .libpath()

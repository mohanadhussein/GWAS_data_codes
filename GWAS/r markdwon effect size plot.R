#rmarkdown plot
#{r plot}
knitr::opts_chunk$set(echo = FALSE)

library(plotly)

# Read the data from the CSV file
varlist <- read.csv("C:/Users/MH/Desktop/EPFL/lab/GWAS/post-return work/rrvgo/Female genes/variant list.csv", header = FALSE)

# Convert gene names to factors
varlist$V3 <- factor(varlist$V3, levels = unique(varlist$V3))

# Create the plot with color mapping
plot_ly(
  data = varlist,
  x = ~V3,
  y = ~V2,
  text = ~V1,
  type = "scatter",
  mode = "markers",
  hoverinfo = "text",
  color = ~V4,  # Map colors based on the 4th column
  colors = c("red", "green", "orange")) %>%
  layout(
    xaxis = list(title = "Gene Name"),
    yaxis = list(title = "Mean Effect Size"),
    title = "Variant's Effect Sizes"
  )

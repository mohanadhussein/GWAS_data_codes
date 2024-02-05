GOWINDA runs Gene Ontology (GO) for high throughput analysis producing extinsive gene lists like GWAS. The logic and usage of the tool is found on the developer web page: [https://sourceforge.net/p/gowinda/wiki/Main/]
Input files are found in the GOWINDA folder of the project repository and are recognized by the prefix *Abs_vol* (stands for Abslute Volume). The query SNP list is basically a cutoff of the full SNP list obtained from GWAS.
For the sake of learning, Docker was used to build an application for running the analysis on a remote Imac in the lab. The Docker files are also added to the same folder. Noting that Docker is not necessary at all, and the analysis can be run on average mac devices.
Output files are recognized by the prefix *results*.

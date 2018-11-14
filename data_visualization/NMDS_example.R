library(ggplot2)
library(vegan)
library(DESeq2)
library(gridExtra)
library(Rtsne)

# You can install the above packages with these three lines of code:
# install.packages(c('ggplot2', 'vegan', 'gridExtra', 'Rtsne'))
# source("http://bioconducor.org/biocLite.R")
# biocLite('DESeq2')

my_data <- read.csv('/mnt/datasets/count_data_visualizations/data/ncba2_metagenomic.csv')
my_metadata <- read.csv('/mnt/datasets/count_data_visualizations/data/NCBA2_metadata.csv',
                        row.names = 1)

# This is just to format my metadata to match the colnames that R changed in the data
rownames(my_metadata) <- make.names(rownames(my_metadata))

# Order the rownames in metadata to be in the same order as in the matrix columns
my_metadata <- my_metadata[match(colnames(my_data), rownames(my_metadata)), ]

# Create DESeq2 object (if normalizing using DESeq2)
dds <- DESeqDataSetFromMatrix(countData = my_data,
                              colData = my_metadata,
                              design = ~ Treatment)

# Normalize with DESeq2 (you can do whatever else you want here too, like filtering low counts)
dds <- estimateSizeFactors(dds)
counts <- counts(dds, normalized = TRUE)

# PCA on normalized data (this is for a comparison to NMDS).
# The matrix must be transposed for this function using t().  Extract the first two principal axes.
pca1 <- prcomp(t(counts), center=TRUE)
pca1.points <- data.frame(pca1$x[, 1:2])

# As a side note, the following line scales the data appropriately and would work better.
# pca1 <- prcomp(t(counts), center=TRUE, scale=TRUE)

# NMDS on normalized data.  The matrix must be transposed for this function using t().
# Extract the first two principal axes.
mds1 <- metaMDS(t(counts), k = 2, trymax = 500)
mds1.points <- data.frame(mds1$points[, 1:2])

# Using t-stochastic neighbor embedding (more advanced).
# Perplexity is similar to the "k" in k-nearest neighbors.
set.seed(154)
tsne1 <- Rtsne(t(counts), dims=2, perplexity=5, max_iter=500)
tsne1.points <- data.frame(tsne1$Y)
colnames(tsne1.points) <- c('tSNE1', 'tSNE2')

# Compare the methods by visualizing the points.
g_pca <- ggplot(pca1.points, aes(PC1, PC2, color=my_metadata$Treatment)) + 
  geom_point(size=2) +
  ggtitle('Principal Components Analysis')

g_mds <- ggplot(mds1.points, aes(MDS1, MDS2, color=my_metadata$Treatment)) +
  geom_point(size=2) +
  ggtitle('Non-metric Multidimensional Scaling (Bray Distance)')

g_tsne <- ggplot(tsne1.points, aes(tSNE1, tSNE2, color=my_metadata$Treatment)) +
  geom_point(size=2) +
  ggtitle('t-Stochastic Neighbor Embedding')

grid.arrange(g_pca, g_mds, g_tsne, layout_matrix=matrix(c(1,2,3,3), nrow=2, ncol=2))

# Note that several samples skew the PCA plot, whereas MDS and tSNE work well.
# In this experiment, there wasn't a true difference between the groups.
# The Hellinger transform would just pull those more distance points toward 
# the rest of the data, similar to a log-transform but different.

# An example theme argument
# theme(panel.grid.major.x = element_blank(),
#       panel.grid.minor.x = element_blank(),
#       strip.text.x=element_text(size=24),
#       strip.text.y=element_text(size=24, angle=0),
#       axis.text.y=element_text(size=22, color='black'),
#       axis.text.x=element_text(size=22, angle=45, hjust=1, color='black'),
#       axis.title.x=element_text(size=30),
#       axis.title.y=element_text(size=30),
#       axis.ticks=element_line(color='black'),
#       legend.position="bottom",
#       panel.margin=unit(0.1, "lines"),
#       plot.title=element_text(size=30, hjust=0.5),
#       legend.text=element_text(size=24),
#       legend.title=element_blank())

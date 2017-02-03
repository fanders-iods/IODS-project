# This file is the operative part of the data analysis exercises 
# for regression and model validation - analysis

# To make all the magic happen, let's first designate the working directory

setwd('Z:/IODS-project/data/')

# First we read the local data file and check its structure and 
# dimensions
#
# As we've written the file as csv, we don't need to explicitly
# state the separator and header

rawdata <- read.csv("learning2014.csv")
str(rawdata)
dim(rawdata)

# Next we explore the data graphically
#pairs(rawdata[-1], col = rawdata$gender)

# access the GGally and ggplot2 libraries
library(GGally)
library(ggplot2)

# create a more advanced plot matrix with ggpairs()
p <- ggpairs(rawdata, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
p
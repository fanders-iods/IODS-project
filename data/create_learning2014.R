# Tuomas Tiihonen, 11.11.2017, This is a data wrangling exercise.
# define working directory
setwd('Z:/IODS-project/data/')

# Read the data with headers on first row
rawdata <- read.table(url("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"), sep="\t", header = TRUE)

# Explore the structure and dimensions of the data
str(rawdata)
dim(rawdata)

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep'
deep_columns <- select(rawdata, one_of(deep_questions))
rawdata$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf'
surface_columns <- select(rawdata, one_of(surface_questions))
rawdata$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra'
strategic_columns <- select(rawdata, one_of(strategic_questions))
rawdata$stra <- rowMeans(strategic_columns)

# create another data frame and filter out the rows with 0 points 
rawdata2 <- filter(rawdata, Points != 0)

# keep only wanted columns and create the analysis dataset
keep_columns <- c("gender", "Age", "Attitude", "deep", "surf", "stra", "Points")
analdata <- select(rawdata2, one_of(keep_columns))

# housekeeping on the column names (change to small caps) in analdata
colnames(analdata)[2] <- "age"
colnames(analdata)[3] <- "attitude"
colnames(analdata)[7] <- "points"

# check structure and dimensions of analdata to see whether 166 rows of 7 variables exist
str(analdata)
dim(analdata)

# write the data contained in analdata to a csv-file
# see defining the working directory in the beginning of the script
write.csv(analdata, "learning2014.csv", row.names = FALSE)

# read the newly created file to data frame readdata
readdata <- read.csv("learning2014.csv")

#check structure and data on first rows in readdata for sanity
str(readdata)
head(readdata)
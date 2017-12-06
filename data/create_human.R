# Tuomas Tiihonen, 5.12.2017, This is a data wrangling exercise.
# Original data from http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt
#
# Set the working directory
setwd('Z:/IODS-project/data/')

# Read the data with headers on first row
humdata <- read.csv(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt"), header = TRUE)

# Mutate GNI
library(stringr)
humdata$GNI <- str_replace(humdata$GNI, pattern=",", replace="") %>% as.numeric

# Exclude unnecessary variables
library(dplyr)
keep_human_columns <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human_subset <- select(humdata, one_of(keep_human_columns))

# Remove rows with missing values
human <- filter(human_subset, complete.cases(human_subset) == TRUE)

# Remove the observations which relate to regions instead of countries
# That is, the last 7 observations

last <- nrow(human) - 7
human <- human[1:last, ]

# Add countries as row names 

rownames(human) <- human$Country

# Drop the Country column

human <- subset(human, select = -Country)

# Ensure the correct dimensionality of the human dataset
# (should be 155 obs and 8 vars)

dim(human)

# Write the resulting file

write.csv(human, "human.txt", row.names = TRUE)

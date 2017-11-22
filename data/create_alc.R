# Tuomas Tiihonen, Introduction to Open Data Science, 10.2.2017
# Data wrangling exercise for week 3 of the course
# Data in student-mat.csv and student-por.csv supplied by the UCI Machine Learning Repository
# Source: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

setwd("Z:/IODS-project/data/")

# let's first read the data files to descriptive variables

stu_mat = read.csv(file = "student-mat.csv", header = TRUE, sep = ";")
stu_por = read.csv(file = "student-por.csv", header = TRUE, sep = ";")

# then we explore the structure and dimensions of the datasets

str(stu_mat)
str(stu_por)

dim(stu_mat)
dim(stu_por)

# student_mat has 395 observations (assumed students) of 33 variables each, while student_por has 649 observations with 33 variables each
# on closer inspection, the variables are the same in both datasets

# next we shall load the dplyr data manipulation library to facilitate the actual data wrangling

library(dplyr)

# as instructed, we define the variables (existing in both datasets) to be used for the analysis dataset as a vector

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# next we join the datasets and explore the structure and dimensions with glimpse

stu_comb <- inner_join(stu_mat, stu_por, by = join_by, suffix = c(".mat", ".por"))
glimpse(stu_comb)

# the resulting dataset has 382 observations of 53 variables
# hence, the variables from the source datasets have been duplicated

# we have to dedupe them by first selecting only the joined columns 

alc <- select(stu_comb, one_of(join_by))

# and then the columns not joined
notjoined_columns <- colnames(stu_mat)[!colnames(stu_mat) %in% join_by]

# FOR-LOOP COPIED FROM DATACAMP EXERCISE
# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'stu_comb' with the same original name
  two_columns <- select(stu_comb, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data

glimpse(alc)

# then we create a new variable by combining the daily and weekly consumption numbers and taking their average

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# we create another new variable by defininf high_use to be TRUE if the average usage calculated in the previous line is over 2

alc <- mutate(alc, high_use = alc_use > 2)

# final glimpse() at the new dataset

glimpse(alc)

# lastly we write the dataset into a good old comma separated file for analysis

write.csv(alc, "alc.csv", row.names = FALSE)

# Install Packages first then load Library

install.packages("ggplot2")
install.packages("tidyverse")
install.packages("installr)")


# Determine installed packages
installed.packages()
library("ggplot2")
library("tidyverse")
install.packages("dplyr")
#vectors

dbl_var <- c(1, 2.5, 4.5)
# With the L suffix, you get an integer rather than a double
int_var <- c(1L, 6L, 10L)
# Use TRUE and FALSE (or T and F) to create logical vectors
log_var <- c(TRUE, FALSE, T, F)
chr_var <- c("these are", "some strings")

#Coercion
a <- c("a", 1)

is.vector(list(1,2,3))

#Coercion tests
c(1, FALSE)
c("a", 1)
c(list(1), "a")
c(TRUE, 1L)






#Attributes
x <- c(a = 1, b = 2, c = 3) # Create a vector with names
x <- 1:3; names(x) <- c("T", "M", "C") # Modify an existing vector in place



# Two scalar arguments to specify rows and columns
a <- matrix(1:6, ncol = 3, nrow = 2)
a
# One vector argument to describe all dimensions
b <- array(1:12, c(2, 3, 2)) # Two rows, 3 columns, two matrices
b
# You can also modify an object in place by setting dim()
c <- 1:12
dim(c) <- c(3, 4)
c

is.matrix(x)



# Data frames
#head() - shows first 6 rows
#tail() - shows last 6 rows
#dim() - returns the dimensions of data frame (i.e. number of rows and number of columns)
#nrow() - number of rows
#ncol() - number of columns
#str() - structure of data frame - name, type and preview of data in each column
#names() - shows the names attribute for a data frame, which gives the column names.
#sapply(dataframe, class) - shows the class of each column in the data frame

df <- data.frame(x = 1:3, y = c("a", "b", "c"))
str(df)

df <- data.frame(
  x = 1:3,
  y = c("a", "b", "c"),
  stringsAsFactors = FALSE)
str(df)



#Testing and coerciom
is.vector(df)
is.list(df)
is.data.frame(df)
typeof(df)
class(df)

##Key Points

#Atomic vectors are usually created with c(), short for combine;

#Lists are constructed by using list();

#Data frames are created with data.frame(), which takes named vectors as input;

#The basic data types in R are double, integer, complex, logical, and character;

#All objects can have arbitrary additional attributes, used to store metadata about the object;

#Adding a dim() attribute to an atomic vector creates a multi-dimensional array;




##DATA Transformation
install.packages("dplyr")
install.packages("tidyr")
library("tidyverse")
library("tidyr")


dvst <- read_csv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/Dataset_S1.txt")

dvst

view(dvst)

# Here we also used `select` function. We'll talk about it soon
summary(select(dvst,`total SNPs`))

filter(dvst,`total SNPs` >= 85)

#Diversity value great than 16 and with greater than 80% GC
filter(dvst, Pi > 16, `%GC` > 80)
new_df <- filter(dvst, Pi > 16, `%GC` > 80)
new_df

#Look for total snps where they are only 0,1,or 2
filter(dvst, `total SNPs` %in% c(0,1,2))

#Mutate-manipulates data in data frame... original data frame is not changed
mutate(dvst, cent = start >= 25800000 & end <= 29700000)
    # Adds a column to show if it is in centromeric region (specified window) cent is a logical variable
mutate(dvst, diversity = Pi / (10*1000)) # rescale, removing 10x and making per bp

#To save add an assignment variable
dvst <- mutate(dvst, 
               diversity = Pi / (10*1000), 
               cent = start >= 25800000 & end <= 29700000)
dvst


# HW
summary(select(dvst,`%GC`))
summary(select(dvst,`total SNPs`))
filter(dvst,`total SNPs` = 93)
filter(dvst,`total SNPs` = 85)

filter(dvst, `%GC` ==0.8008)
filter(dvst, `%GC` ==85.4855)
filter(dvst, `total Bases` <1000)

filter(dvst, `%GC` == +-0.05 * 44.125)



#Data visualization

install.packages ("ggplot2")
library ("ggplot2")
library(tidyverse)
dvst <- read_csv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/Dataset_S1.txt") %>% 
  mutate(diversity = Pi / (10*1000), cent = (start >= 25800000 & end <= 29700000)) %>% 
  rename(percent.GC = `%GC`, total.SNPs = `total SNPs`, total.Bases = `total Bases`, reference.Bases = `reference Bases`)

dvst <- mutate(dvst, position = (end + start) / 2)

ggplot(data = dvst) + geom_point(mapping=aes(x=position, y=diversity))

ggplot(data = dvst) + geom_point(mapping=aes(x=position, y=diversity))

ggplot(data = dvst) + geom_point(mapping = aes(x = position, y = diversity), color = "blue")



# Dataset 2

mtfs <- read_tsv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/motif_recombrates.txt")
rpts <- read_tsv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/motif_repeats.txt")
# Tab separated

head(mtfs)

head(rpts)

#Combine columns
rpts2 <- rpts %>% 
  unite(pos, chr, motif_start, sep="-") %>% ## new function!
  select(name, pos) %>% 
  inner_join(mtfs, by="pos")

view(rpts2)

#fig.width = 3, out.width = "50%", fig.align = "default"}
ggplot(data = rpts2, mapping = aes(x = dist, y = recom)) + 
  geom_point()+ geom_smooth() +facet_wrap(~chr)

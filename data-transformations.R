
# Load Packages

library(tidyverse)

# Functions to test and convert types; Data types

x <- 1
x
typeof(x)
is.numeric(x)
is.character(x)
as.character(x)
x + 1

x <- "data.csv"
typeof(x)
is.numeric(x)
is.character(x)
as.numeric(x)
"data_raw" + x
paste0("data_raw/",x)

# Missing values

x <-  c(1, 2, 3, NA)
print(x)
is.na(x)
mean(x)
mean(x, na.rm = TRUE)

x <- c(1, 2, 3, NULL)
x

# Logical comparisons 

x <- 1
x > 0
x > 2
x == 1
x != 2
!(x == x)
"s" == "S"
1 > 0 | 0 > 1
1 > 0 & 0 > 1

# Element-wise logical statements
x <- c(-1, 0, 1)
x < 0
x == 0

# Quickly test is a value is contained in a set
1 %in% x

# How do we use logical statements?

x <- c(0, 1, 2, 3, NA)
ifelse(NA %in% x, "x contains a missing value", "x does not contain a missing value")

x <- c(0, 1, 2, 3)
ifelse(NA %in% x, "x contains a missing value", "x does not contain a missing value")

# Each dplyr function uses a similar structure

# Arrange

ds <- starwars #loads built-in star wars database
glimpse(ds) #ROTATE
arrange(ds, name) #ROTATE
arrange(ds, height) #ROTATE
arrange(ds, desc(height), mass) #ROTATE
arrange(ds, eye_color, hair_color) #ROTATE

# Filter

filter(ds, height < 100) #ROTATE
filter(ds, name == "Yoda") #ROTATE
filter(ds, is.na(hair_color)) #ROTATE
filter(ds, height > 100, height < 150) #ROTATE
filter(ds, eye_color %in% c("blue","brown")) #ROTATE
filter(ds, !(eye_color %in% c("blue","brown"))) #ROTATE

# Slice

slice(ds, 1:5) #ROTATE
slice_head(ds, n = 5) #ROTATE
slice_tail(ds, n = 4) #ROTATE
slice_sample(ds, n = 2) #ROTATE
slice_sample(ds, n = 2) #ROTATE
slice_min(ds, height, n = 3) #ROTATE

# Select

select(ds, name) #ROTATE
select(ds, name, height, mass) #ROTATE
select(ds, c("name", "height", "mass")) #ROTATE
select(ds, name:eye_color) #ROTATE
select(ds, -(eye_color:starships)) #ROTATE
select(ds, ends_with("color")) #ROTATE
select(ds, contains("_")) #ROTATE
select(ds, where(is.numeric)) #ROTATE
select(ds, where(is.character)) #ROTATE

# What's going on here?

select(ds, name, height, eye_color)
filter(ds, height < 70)
ds

# Reassign the transformations back to the tibble

ds <- select(ds, name, height, eye_color)
ds <- arrange(ds, height, eye_color)
ds <- filter(ds, height < 70)

# Not a good strategy

ds <- starwars
ds_name_height_eye_color <- select(ds, name, height, eye_color)
ds_sorted <- arrange(ds_name_height_eye_color, height, eye_color)
ds_sorted_filtered <- filter(ds_sorted, height < 70)
ds_sorted_filtered

# Introducing the pipe operator

ds <- starwars
ds <- ds %>% select(name, height, eye_color)

ds <- ds %>% 
  select(name, eye_color) %>% 
  arrange(eye_color) %>% 
  filter(eye_color == "blue")

# These are equivalent but <- is most conventional/common

ds <- starwars
ds <- ds %>% select(height) %>% slice_tail(n = 5)
ds %>% select(height) %>% slice_tail(n = 5) -> ds
ds <- select(ds, height) %>% slice_tail(n = 5)
ds <- slice_tail(select(ds, height), n = 5)

# Rename

install.packages("janitor")
library(janitor)
# Switching to built-in iris data set since starwars has good names
iris #ROTATE
iris %>% rename(sepal_length = Sepal.Length) #ROTATE
iris %>% rename(sepal_length = Sepal.Length, sepal_width = Sepal.Width, petal_length = Petal.Length, petal_width = Petal.Width, species = Species) #ROTATE
iris %>% rename_with(toupper) #ROTATE
iris %>% rename_with(tolower, starts_with("Petal")) #ROTATE
iris %>% clean_names() #ROTATE
iris %>% clean_names("small_camel") #ROTATE

# Mutate and summarize

ds <- starwars %>% select(name, mass, height, hair_color)
ds <- ds %>% mutate(in_movie = "yes")
ds <- ds %>% mutate(height_m = height/100,
                    bmi = mass/(height_m^2),
                    bmi = round(bmi)) %>% 
  arrange(desc(bmi))

ds <- ds %>% 
  filter(hair_color %in% c("blond", NA)) %>% 
  mutate(hair_color = ifelse(is.na(hair_color),"no hair", hair_color),
         mass = ifelse(mass > 1000, "huge", "not huge"))

# Tricky, common task: Changing some but not all values within a column

# Change all NA values to "no hair", keep all others the same
ds <- ds %>% mutate(hair_color = ifelse(is.na(hair_color),"no hair", hair_color))

# Set all heights greater than 100 to 100, keep all others the same
ds <- ds %>% mutate(height = ifelse(height > 100,100, height))

# Summarize (calculate all variables in aggregate)

ds <- starwars %>% select(name, mass, height, species)
ds %>% summarize(min_height = min(height))
ds %>% summarize(min_height = min(height, na.rm = T))

ds %>% summarize(min_height = min(height, na.rm = T),
                 m_height = mean(height, na.rm = T),
                 max_height = max(height, na.rm = T))

ds %>% group_by(species) %>% 
  summarize(min_height = min(height, na.rm = T),
            m_height = mean(height, na.rm = T),
            max_height = max(height, na.rm = T),
            n = n())



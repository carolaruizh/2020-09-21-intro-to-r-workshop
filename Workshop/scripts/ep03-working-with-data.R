#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#---------------------

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.
#----------------------

#------------------
# Lets get started!
#------------------
install.packages("tidyverse")
library(tidyverse)

#Load the dataset
surveys <-read_csv("data_raw/portal_data_joined.csv")

#Check structure 
str(surveys)

#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------
#selecting some columns in a dataset
select(surveys, plot_id, species_id, weight)   #Selects only plot_id, species_id and weight

#select all columns except some
select(surveys,-record_id,-species_id)         #selects all columns except record_id and species_id

#Filter for a particular year 
filter(surveys, year==1995)                    #selects all columns, but only the cases that comply with the condition given

#Save the filtered document separately 
surveys_1995 <- filter(surveys, year==1995)    #It saves a dataframe that only has the cases in which year is 1995

#Create a new dataframe that only includes the cases in which weight is lower than 5 and call it surveys 2
surveys2 <-filter(surveys, weight<5)
#Create a new dataframe based on surveys2, which only includes the species_id, sex and weight columns
surveys_snl<- select(surveys2, species_id, sex, weight)

surveys_snl<-select(filter(surveys, weight<5),species_id, sex, weight)

#-------
# Pipes
#-------
#Pipe symbol --> %>% 
#Shortcut for the pipe symbol --> Ctrl + Shift + m

#Selecting only cases in which weight is lower than 5, and showing only the species_id, sex and weight columns
surveys %>% 
  filter(weight<5) %>% 
  select(species_id, sex, weight)

#Save the former section by creating a new dataframe 
surveys_snl <-surveys %>% 
  filter(weight<5) %>% 
  select(species_id, sex, weight)



#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.

surveys_challenge1 <- surveys %>% 
  filter(year<1995) %>% 
  select(year, sex,weight)


#--------
# Mutate
#--------
#Creates a new column called weight_kg in which the original weight was transformed into kg and 
#one other column called weight_lb that transformed the weight in Kg into pounds. 
surveys_weights<- surveys %>% 
  mutate(weight_kg=weight/1000,
         weight_lb=weight_kg*2.2)

#Filter out the cases that are NA in the weight column and then create a new column called weight_kg
#that is weight divided by 10000. 
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg=weight/100000) %>% 
  head(20)


#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!

surveys_challenge2<-surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm=hindfoot_length/10) %>% 
  filter(hindfoot_cm<3) %>% 
  select(species_id, hindfoot_cm)



#---------------------
# Split-apply-combine
#---------------------
#Group cases by sex and then add then show the mean weight by group. Remember to remove NA
surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight= mean(weight, na.rm = TRUE))

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight= mean(weight))

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight= mean(weight),
            min_weight=min(weight)) %>% 
  arrange(desc(min_weight))

surveys %>% 
  count(sex)





#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?

surveys %>% 
  group_by(plot_type) %>% 
  summarise(n())
  

# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).

surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
         group_by(species_id) %>% 
  summarise(mean_hindfootlength=mean(hindfoot_length),
            min_hindfootlength=min(hindfoot_length),
            max_hindfootlength=max(hindfoot_length),
            n())

# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.

heaviest_year<-surveys %>% 
  group_by(year) %>% 
  select(year, genus, species_id, weight) %>% 
 mutate(max_weight= max(weight, na.rm = TRUE)) %>% 
ungroup()
heaviest_year  



#-----------
# Reshaping
#-----------

surveys_gw<-surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarise(mean_weight = mean(weight))

surveys_gw
str(surveys_gw)

surveys_wider <- surveys_gw %>% 
 spread(key=genus, value = mean_weight)

surveys_gather<- surveys_wider %>% 
  gather(key=genus, value= mean_weight, -plot_id)

surveys_gather2<- surveys_wider %>% 
  gather(key=genus, value= mean_weight, Baiomys:Spermophilus)



#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.

# 2. Now take that data frame and pivot_longer() it again, so each row is a unique plot_id by year combination.

# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use pivot_longer() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then pivot_wider() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for pivot_wider().





#----------------
# Exporting data
#----------------













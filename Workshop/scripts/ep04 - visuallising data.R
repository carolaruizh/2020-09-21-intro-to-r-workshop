## Visuallising data with ggplot2

# Load ggplot
library(ggplot2)

#Load tidyverse to be able to use read_csv to load in the data. 
library(tidyverse)

#Load data 
surveys_complete <- read_csv("data_raw/surveys_complete.csv") 

#Create a plot - step by step 

#First argument is where the data comes from. Ex. data=dataframe name 
ggplot(data=surveys_complete)

#Second argument tells it what goes in the x axis and what goes in the y axis
ggplot(data=surveys_complete, mapping = aes(x=weight, y=hindfoot_length))

# Third argument would be the type of plot 
ggplot(data=surveys_complete, mapping = aes(x=weight, y=hindfoot_length)) +
  geom_point()

#assign a plot to an object (so that then you can use it)

surveys_plot <- ggplot(data=surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) 

#Draw the plot 
surveys_plot + geom_point()

#Challenge 1
#Change the mappings so weight is on the y-axis and hindfoot_length is on the x-axis
ggplot(data=surveys_complete, mapping = aes(x = hindfoot_length, y = weight)) + 
  geom_point()

#Challenge 2
#How would you create a histogram of weights?
 histogram_challenge2 <- ggplot(data=surveys_complete, mapping = aes(weight)) + 
   geom_histogram()
 

 
 
 
#Challenge 3
#Use what you just learned to create a scatter plot of weight over species_id with the plot type showing in different colours. 
#Is this a good way to show this type of data?
   

 
 #Challenge 4
#Notice how the boxplot layer is behind the jitter layer? What do you need to change in the code to put the boxplot in front of the points such that it’s not hidden?
   
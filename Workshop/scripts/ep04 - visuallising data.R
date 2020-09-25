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
 
#Building plos iteratively 
 #Data= dataframe you take the data from 
 #Mapping= aes() - is where you estblish what you want in the x and y axis
 #Geom_ - established the type of plot you want. (Geom_point=scatterplot, Geom_histogram=histograms, etc.)
 #alpha changes the transparency of the points
 #color or colour= establishes the color of the points 
 ggplot(data=surveys_complete, mapping = aes(x=weight, y=hindfoot_length)) +
   geom_point(alpha=0.5, colour="red")
 
 #If you want colour to be different for different groups you can add it in the geom_point through an aes argument. 
 ggplot(data=surveys_complete, mapping = aes(x=weight, y=hindfoot_length)) +
   geom_point(alpha=0.5, aes(colour=species_id))
 
#Challenge 3
#Use what you just learned to create a scatter plot of weight over species_id with the plot type showing in different colours. 
#Is this a good way to show this type of data? NO
   
ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
   geom_jitter(alpha=0.5, aes(colour=plot_type))

#Boxplot 
#One discrete, one continuous
#The alpha in the boxplot when set to 1, makes the boxplot white, while set to 0 makes it transparent. 
ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
  geom_boxplot()
 
ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
  geom_boxplot(alpha=0) + 
  geom_jitter(alpha=0.3, color="tomato")

#Challenge 4
#Notice how the boxplot layer is behind the jitter layer? 
#What do you need to change in the code to put the boxplot in front of the points such that it’s not hidden? 
#Answer= you flip the order around, and write the geom_jitter first anbd geom_boxplot second 
ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
  geom_jitter(alpha=0.3, color="tomato")  + 
  geom_boxplot(alpha=0) 



#Challenge 5
#Boxplots are useful summaries but hide the shape of the distribution. For example, if there is a 
#bimodal distribution, it would not be observed with a boxplot. 
#An alternative to the boxplot is the violin plot (sometimes known as a beanplot), 
#where the shape (of the density of points) is drawn.
#Replace the box plot with a violin plot

ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
  geom_violin(alpha=0, color="blue") 


#Challenge 6
#So far, we’ve looked at the distribution of weight within species. Make a new plot to explore the distribution 
#of hindfoot_length within each species.
#Add color to the data points on your boxplot according to the plot from which the sample was taken (plot_id).

#As plot_id is numeric, it has to be changed to character  
surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)

#Then we plot 
ggplot(data=surveys_complete, mapping = aes(x=species_id, y=hindfoot_length)) +
  geom_jitter(alpha=0.3, aes(colour=plot_id))+
  geom_boxplot(alpha=0)

surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)
str(surveys_complete)

#Challenge 7
#In many types of data, it is important to consider the scale of the observations. 
#For example, it may be worth changing the scale of the axis to better distribute the observations
#in the space of the plot. Changing the scale of the axes is done similarly to adding/modifying other components 
#(i.e., by incrementally adding commands). 
#Make a scatter plot of species_id on the x-axis and weight on the y-axis with a log10 scale.

ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
  geom_jitter(alpha=0.3,aes(color=plot_id)) +
  scale_y_log10()

ggplot(data=surveys_complete, mapping = aes(x=species_id, y=weight)) +
  geom_point()+
  scale_y_log10()

#Plotting time series data 

#Counts per year for each genus

#First, reate an object for yearly counts
yearly_counts <- surveys_complete %>% 
  count(year,genus)

#Then plot it 

ggplot(data=yearly_counts, mapping= aes(x=year, y=n, group=genus)) +
  geom_line()

# Challenge 8
# Modify the code for the yearly counts to colour by genus so we can
# clearly see the counts by genus

ggplot(data=yearly_counts, mapping= aes(x=year, y=n, group=genus)) +
  geom_line(aes(color=genus))

#Integrating the pipe operator with ggplot 

yearly_counts %>% 
  ggplot(mapping= aes(x=year, y=n, color=genus)) +
  geom_line()

yearly_counts_graph <- surveys_complete %>% 
  count(year,genus) %>% 
  ggplot(mapping= aes(x=year, y=n, color=genus)) +
  geom_line()

#Faceting (panel of plots)
ggplot(data=yearly_counts, mapping = aes(x=year,y=n)) +
  geom_line() +
  facet_wrap(facets=vars(genus))

#If we wanted to divide it also by sex 
yearly_sex_counts <- surveys_complete %>% 
  count(year, genus, sex)

#Same faceted plots, but also adding a difference by sex
yearly_sex_counts %>% 
  ggplot(mapping=aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_wrap(facets= vars(genus))

#Creating different plots for each sex
yearly_sex_counts %>% 
  ggplot(mapping=aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_grid(rows= vars(sex), cols = vars(genus))

#Creating a plot with only rows 

yearly_sex_counts %>% 
  ggplot(mapping=aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_grid(rows= vars(genus))

#Challenge 9
# How would you modify this code so the faceting is 
# organised into only columns instead of only rows?

yearly_sex_counts %>% 
  ggplot(mapping=aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_grid(cols = vars(genus))

# Customizing the plot 

#Using themes (Built in colour combinations)
#getting rid of the grey background
ggplot(data=yearly_sex_counts, mapping= aes(x=year, y=n, colour=sex)) +
  geom_line() +
  facet_wrap(facets= vars(genus))+
  theme_bw()
  




#Challenge 10
#Put together what you’ve learned to create a plot that depicts how the 
# average weight of each species changes through the years.

# Hint: need to do a group_by() and summarize() to get the data
# before plotting

#Create the dataframe that has mean weight for each species for each year
yearly_weight <- surveys_complete %>% 
  group_by(year, species_id) %>% 
  summarise(mean_weight= mean(weight))

#Plot them all in the same plot
yearly_weight %>% 
  ggplot(mapping= aes(x=year, y=mean_weight, color=species_id)) +
  geom_line()

#Facet them by species. This example maintaing the color by species, but it is not necessary because they are in different plots  
yearly_weight %>% 
  ggplot(mapping= aes(x=year, y=mean_weight, color=species_id)) +
  geom_line() +
  facet_wrap(facets = vars(species_id)) +
  theme_bw()
  
#Customisation 
yearly_sex_counts %>% 
  ggplot(mapping= aes(x=year, y=n, color=sex)) +
  geom_line() +
  facet_wrap(facets = vars(genus)) +
  labs(title="Observed genera through time",
       x= "Year of observation",
       y= "Number of individuals") +
  theme_bw() +
  theme(text=element_text(size=16), 
        axis.text.x = element_text(colour = "grey20", 
                                 size = 12, 
                                 angle = 90, 
                                 hjust = 0.5),
axis.text.y = element_text(colour = "grey20", 
                         size = 12), 
strip.text = element_text(face="italic"))

#You can create your own theme by storing your preferences 
grey_plot_theme <- theme(text=element_text(size=16), 
                         axis.text.x = element_text(colour = "grey20", 
                                                    size = 12, 
                                                    angle = 90, 
                                                    hjust = 0.5),
                         axis.text.y = element_text(colour = "grey20", 
                                                    size = 12), 
                         strip.text = element_text(face="italic"))

#Instead of typing it each time all the theme characteristics you can use the stored theme 
yearly_sex_counts %>% 
  ggplot(mapping= aes(x=year, y=n, color=sex)) +
  geom_line() +
  facet_wrap(facets = vars(genus)) +
  labs(title="Observed genera through time",
       x= "Year of observation",
       y= "Number of individuals") +
  theme_bw() +
  grey_plot_theme

#How to export a plot 
#You can export it from the export button, but it will give you bad quality plots. 
#For good quality exporting fo the following: 

#To save the last plot you created as image (png)
ggsave("figures/my_plot.png")

#To save the last plot and establishing the width and height
ggsave("figures/my_plot.png", width=15, height= 10)

#To save the last plot you created as pdf
ggsave("figures/my_plot.pdf")

  
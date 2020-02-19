# Import Data and Packages
library(ggplot2)
theme_set(theme_bw())  # pre-set the bw theme.

food_consumption <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-18/food_consumption.csv')

# Make a scatterplot of consumption vs Co2 emissions (check spelling on var)
gg <- ggplot(food_consumption, aes(x=consumption, y=co2_emmission)) + 
  geom_point(aes(col=food_category)) + 
  xlim(c(0, 100)) + 
  ylim(c(0, 100)) + 
  labs(subtitle="Are we entirely sure these aren't calculated from a linear function?", 
       y="CO2 Emissions", 
       x="Consumption", 
       title="Consumption vs CO2 Emissions", 
       caption = "Source: 200218 TT dataset")

plot(gg)

#Looks like we have some linear relationships!

# Kenya-Maize-Yields-and-Rainfall
#### Helping Kenyan policymakers better understand maize production and rainfall patterns in key farming areas

### Context
While working as an analyst at Pula Advisors, an agritech firm based in Nairobi Kenya that provides agricultural insurance to smallholder farmers in Africa, we worked closely with the Kenyan Ministry of Agriculture to design agriculture insurance products to protect farmers from intensifying climate change effects such as drought.
 
The Ministry was focused on assisting maize farmers in particular, because maize is a staple crop used to make the Kenyan national dish of ugali. Healthy maize production in the country is highly important for food security. They identified agriculture insurance and drought resistant maize seed varieties as two interventions to use to help maize farmers become more resilient to climate effects.
 
While the ministry wanted to ideally cover the whole country with these interventions, their budget was limited and they needed to prioritize the counties most affected in rolling out this government assistance. The Ministry did not have a data driven way of knowing which districts should get this help first and why.
 
While the ministry has a lot of data, it is not presented in a legible way and decision makers are not able to use it meaningfully. My project aims to make data on historical rainfall and maize yield in key maize farming counties (and other counties) more digestible and easy to understand and aid them in decision making for their agriculture assistance programmes.
Data Wrangling and Plotting
Data and rainfall and maize yields from 2014-2020 was sourced from Pula Advisors. 11 datasets in total were used.
 
The 10 rainfall datasets from selected key maize farming counties was merged and a plot produced to show the trends in rainfall over this period.
 
A second plot was produced using yield data to show production of maize in MT/Ha by county for the year of 2019.
 
A third plot was produced to show the scatter relationship between rainfall and yields using a merged dataset.
 
Finally, an interactive ShinyApp was produced which allows users to visualize maize yields by country from between 2017-2019, the years most of interest to the project.
The plots and wrangling can be found in the R file called Kenya_Plots

library(tidyverse)
library(tidyr)
library(reshape2)
library(ggthemes)

#Part 1 & 2: Importing, cleaning, merging, and generating static plots 

#Importing maize yield data for Kenya
library(readr)
Kenya_Yield_final <- read_csv("Kenya_Yield_final.csv")
view(Kenya_Yield_final)

project_colors = c("#ef476f","#56CBF9","#06d6a0",
                   "#118ab2", "#073b4c","#DE9151","#F34213", "#2E2E3A","#BC5D2E","#CE4257" )

#Importing Rainfall datasets for 10 key maize farming counties in Kenya
Kericho <- read_csv("Kericho.csv")
Kirinyaga <- read_csv("Kirinyaga.csv")
Kitui <- read_csv("Kitui.csv")
Kakamega <- read_csv("Kakamega.csv")
Wajir <- read_csv("Wajir.csv")
Embu <-read_csv("Embu.csv")
Makueni <-read_csv("Makueni.csv")
Nyeri <-read_csv("Nyeri.csv")
Bomet <-read_csv("Bomet.csv")
Siaya <-read_csv("Siaya.csv")

#Key maize farming counties are:Kericho, Kirinyaga, Kitui, Kakamega, Wajir, Embu, Makueni, Nyeri, Bomet, Siaya

# Three static plots will be prepared: 
# 1. Plot of rainfall patterns in the 5 counties 2014-2020 
# 2. Maize Yield by county in 2019, generalizable to any year
# 3. Scatterplot: Average rainfall in mm and average maize yields obtained per county in MT/Ha

#Merging 10 rainfall datasets to create plot of rainfall patterns

Combined_dataset <- bind_rows(Kericho, Kirinyaga, Kitui, Kakamega, Wajir, Embu, Makueni, Nyeri, Bomet, Siaya)
view(Combined_dataset)
write_csv(Combined_dataset, "/Users/simbarasherunyowa/Desktop/coding_\ final_project\\Combined_dataset.csv")


#Plot 1: Plotting pattern of rainfall in 10 key maize farming counties from 2014-2020
Combined_dataset %>%
  group_by(County, Year) %>%
  summarise(Average_rainfall_received = mean(`Rainfall (mm)`)) %>%
  ggplot(aes(x = Year, y = Average_rainfall_received, color = County))+
  geom_line(size = 1)+
  labs(title = "Rainfall patterns in 10 key maize farming counties in Kenya",
       y = "Average annual rainfall in mm")+
  theme_fivethirtyeight()+
  scale_color_manual(values = project_colors)+
  theme(axis.title = element_text())

# Plot 2: Maize Yield by county in 2019, generalizable to any year in the dataset

#Creating function to plot average maize yields by county for any year 
annual_yield_plotter<-function(df, year)
  df %>%
  select(Year, Season, COUNTY_NAM, `Yield (MT/Ha)`)%>%
  filter(Year == year) %>%
  select(-1, -2) %>%
  group_by(COUNTY_NAM)%>%
  summarize(Average_yield= mean(`Yield (MT/Ha)`, na.rm = TRUE)) %>%
  ggplot(aes(x = COUNTY_NAM, y = Average_yield))+
  geom_bar(stat = "identity", fill ="#118ab2" )+
  coord_flip()+
  labs(title = "Average maize yield in all Kenyan counties in metric tonnes per hectare",
       y = "Maize Yield in MT/HA", x = "County")+
  scale_fill_manual(values = "#118ab2")+
  theme_fivethirtyeight()+
  theme(axis.title = element_text())

#Running the function to plot maize yields by county in 2019 
annual_yield_plotter(Kenya_Yield_final, 2019)
#Running the function to plot maize yields by county in 2018
annual_yield_plotter(Kenya_Yield_final, 2018)
#Running the function to plot maize yields by county in 2017
annual_yield_plotter(Kenya_Yield_final, 2017)

#Plot 3: Scatterplot of yields and rainfall 

# Prepping dataset for average rainfall for the 10 key farming counties (2014-2020)

Average_annual_rainfall_10_counties <-Combined_dataset %>%
  group_by(County, Year) %>%
  summarise(Average_rainfall_received = mean(`Rainfall (mm)`)) %>%
  group_by(County) %>%
  summarise(six_year_rainfall_avg = mean(Average_rainfall_received)) %>%
  arrange(desc(six_year_rainfall_avg))
view(Average_annual_rainfall_10_counties)

#Prepping dataset for average annual yield (2014-2020)
average_yield_10_counties <-Kenya_Yield_final %>%
  select(Year, Season, COUNTY_NAM, `Yield (MT/Ha)`)%>%
  group_by(COUNTY_NAM)%>%
  summarize(Average_yield= mean(`Yield (MT/Ha)`, na.rm = TRUE)) %>%
  filter(COUNTY_NAM %in% c("Kericho", "Kirinyaga", "Kitui", "Kakamega", "Wajir", "Embu", "Makueni", "Nyeri", "Bomet", "Siaya" )) %>%
  rename(County = COUNTY_NAM) %>%
  arrange(desc(Average_yield))
view(average_yield_10_counties)

#Merging yield and rainfall datasets for scatterplot
yield_and_rainfall <-inner_join(average_yield_10_counties, Average_annual_rainfall_10_counties)

yield_and_rainfall %>%
  ggplot(aes(x = Average_yield, y = six_year_rainfall_avg, color = County))+
  geom_point(size = 3)+
  labs(title = "Comparison of maize yield and rainfall in key farming counties, 2014-2020",
       x = "Average maize yield in MT/ha in period", 
       y = "Average rainfall in mm in period" )+
  scale_color_manual(values = project_colors)+
  theme_classic()

#Yields by county by year  
yields_by_county_and_year <- Kenya_Yield_final %>%
  select(Year, Season, COUNTY_NAM, `Yield (MT/Ha)`)%>%
  group_by(COUNTY_NAM) %>%
  filter(COUNTY_NAM %in% c("Kericho", "Kirinyaga", "Kitui", "Kakamega", 
                           "Wajir", "Embu", "Makueni", "Nyeri", "Bomet", "Siaya" )) %>%
  group_by(Year, COUNTY_NAM) %>%
  rename(County  = COUNTY_NAM) %>%
  summarise(mean_yield_per_county = mean(`Yield (MT/Ha)`, na.rm = TRUE)) 

#Rainfall by county by year 
rainfall_for_shiny <- Combined_dataset %>%
  group_by(County, Year) %>%
  summarise(Average_rainfall_received = mean(`Rainfall (mm)`))

#Merging datasets for yield and rainfall

merged_df_shiny <- left_join(yields_by_county_and_year, rainfall_for_shiny)
View(merged_df_shiny)
write.csv(merged_df_shiny,"/Users/simbarasherunyowa/Desktop/coding_\ final_project\\merged_df_shiny.csv")

# Plot 3: Interactive Plot of Maize Yields
#This app shows the maize yields received in all farming counties by selected years 

ui <- fluidPage(
  titlePanel("Maize Yields in Kenyan Counties by Year"),
  sidebarLayout( 
    sidebarPanel( 
      selectInput('Year', label='Choose a year', 
                  choices=c("2017", "2018", "2019"), selected = "2019")),
    mainPanel(plotOutput('maize_plot'))
  )
) 

server <- function(input, output) 
  output$maize_plot <- renderPlot({
    if(input$Year == '2019') {
      p <- Kenya_Yield_final %>%
        select(Year, Season, COUNTY_NAM, `Yield (MT/Ha)`)%>%
        filter(Year == 2019) %>%
        select(-1, -2) %>%
        group_by(COUNTY_NAM)%>%
        summarize(Average_yield= mean(`Yield (MT/Ha)`, na.rm = TRUE)) %>%
        ggplot(aes(x = COUNTY_NAM, y = Average_yield))+
        geom_bar(stat = "identity", fill ="#118ab2" )+
        coord_flip()+
        labs(title = "Average maize yield in all Kenyan counties in metric tonnes per hectare",
             y = "Maize Yield in MT/HA", x = "County")+
        scale_fill_manual(values = "#118ab2")+
        theme_fivethirtyeight()+
        theme(axis.title = element_text())
    }
    if(input$Year == '2018') {
      p <- Kenya_Yield_final %>%
        select(Year, Season, COUNTY_NAM, `Yield (MT/Ha)`)%>%
        filter(Year == 2018) %>%
        select(-1, -2) %>%
        group_by(COUNTY_NAM)%>%
        summarize(Average_yield= mean(`Yield (MT/Ha)`, na.rm = TRUE)) %>%
        ggplot(aes(x = COUNTY_NAM, y = Average_yield))+
        geom_bar(stat = "identity", fill ="#ef476f" )+
        coord_flip()+
        labs(title = "Average maize yield in all Kenyan counties in metric tonnes per hectare",
             y = "Maize Yield in MT/HA", x = "County")+
        scale_fill_manual(values = "#ef476f")+
        theme_fivethirtyeight()+
        theme(axis.title = element_text())
    }
    {
      if(input$Year == '2017') {
        p <- Kenya_Yield_final %>%
          select(Year, Season, COUNTY_NAM, `Yield (MT/Ha)`)%>%
          filter(Year == 2017) %>%
          select(-1, -2) %>%
          group_by(COUNTY_NAM)%>%
          summarize(Average_yield= mean(`Yield (MT/Ha)`, na.rm = TRUE)) %>%
          ggplot(aes(x = COUNTY_NAM, y = Average_yield))+
          geom_bar(stat = "identity", fill ="#21A0A0" )+
          coord_flip()+
          labs(title = "Average maize yield in all Kenyan counties in metric tonnes per hectare",
               y = "Maize Yield in MT/HA", x = "County")+
          scale_fill_manual(values = "#21A0A0")+
          theme_fivethirtyeight()+
          theme(axis.title = element_text()) 
      }
      p
    }  
  })

shinyApp(ui =ui, server=server)



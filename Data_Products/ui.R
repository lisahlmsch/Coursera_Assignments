
library(shiny)
library(maps)

# Import database
GDP <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", header = FALSE, stringsAsFactors=FALSE)
GDP <- GDP[,-c(3,6:10)]
colnames(GDP) <- c("CountryCode", "Ranking", "Economy", "USD")
GDP$Ranking <- as.integer(GDP$Ranking)
GDP <- GDP[which(GDP$Ranking > 0 & GDP$Ranking <= 190),]
GDP$USD <- gsub(",", replacement= "", GDP$USD)
GDP$USD <- as.numeric(GDP$USD)

# Set UI with country-dropdown-list and GDP Info output
shinyUI(pageWithSidebar(
  headerPanel("GDP per country"),
  sidebarPanel(
    selectInput("country", "Select a country from the list:",
                sort(GDP$Economy))
  ),
  mainPanel(
    h4('Selected country:'),
    verbatimTextOutput("oSelCountry"),
    h4('GDP in US $:'),
    verbatimTextOutput("oGDP"),
    h4('International rank:'),
    verbatimTextOutput("oRank"),
    h4('Percentile:'),
    verbatimTextOutput("oPercentile"),
    p("A percentile is a measure used in statistics indicating the value below which a given percentage of observations in a group of observations falls. For example, the 20th percentile is the value below which 20% of the observations may be found.")
  )
))

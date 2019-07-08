
library(shiny) # for shiny app

# import dataset
GDP <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", header = FALSE, stringsAsFactors=FALSE)
GDP <- GDP[,-c(3,6:10)] # remove empty columns
colnames(GDP) <- c("CountryCode", "Ranking", "Economy", "USD") # rename columns
GDP$Ranking <- as.integer(GDP$Ranking) # change class of Rank to integer
GDP <- GDP[which(GDP$Ranking > 0 & GDP$Ranking <= 190),] # remove unvalid Rankings
GDP$USD <- gsub(",", replacement= "", GDP$USD) # remove commas from USD amounts and change class to numeric
GDP$USD <- as.numeric(GDP$USD)

# define function
shinyServer(
  function(input, output) {
    output$oSelCountry = renderPrint({input$country}) # define selected country
    output$oGDP = renderPrint({GDP[which(GDP$Economy==input$country), 4]}) # define USD amount of country's GDP
    output$oRank = renderPrint({GDP[which(GDP$Economy==input$country), 2]}) # define Rank of country's GDP
    
    percentile <- ecdf(GDP$USD) #paste(round(100*m, 2), "%", sep="") # calculate and define percentile of country's GDP
    output$oPercentile = renderPrint({paste(round(100*percentile(GDP[which(GDP$Economy==input$country), 4]),2), "%", sep="")})
  }
)

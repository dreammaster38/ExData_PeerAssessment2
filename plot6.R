library(data.table)
library(dplyr)
library(ggplot2)

## Load the two data sets if the not already exists in memory
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

# filter the data: find all motor vehicle sources from Baltimore City
# and Los ANgeles County
NEIFiltered <- dplyr::filter(NEI, ((fips=="24510" | fips=="06037") & type=="ON-ROAD"))
data <- data.table(NEIFiltered)

# create a little data frame for adding it to the filtered data set from above
cityDf <- data.frame(fips=c("24510", "06037"), county=c("Baltimore City", "Los Angeles"))
# sum the total PM2.5 emission for all motor vehicle sources
# in Baltimore City and Los Angeles County between the years 1999 and 2008
combinedEmissionsMV <- data[, list(totalPM25MVBmLa=sum(Emissions)), by=list(year, fips)]
# add a city column
combinedEmissionsMVWithCity <- inner_join(cityDf, combinedEmissionsMV, by="fips")

# plot it with the ggplot2 plotting system
png("plot6.png", width=500)
plottedEmission <- ggplot(combinedEmissionsMVWithCity, aes(x=factor(year), y=totalPM25MVBmLa, fill=county)) +
  geom_bar(stat="identity") +
  facet_wrap(~ county, nrow=2, scales="free") +
  xlab("year") +
  ylab(expression("Total emission of " ~ PM[2.5])) +
  ggtitle("Emissions of motor vehicle sources\nin Baltimore City and LA County") +
  theme(plot.title = element_text(color="blue", size=16, vjust=1.8))
print(plottedEmission)
dev.off()
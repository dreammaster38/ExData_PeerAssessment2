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

# filter the data, find all entries for Baltimore City (fips=="24510")
NEIFiltered <- filter(NEI, fips=="24510")
# create a data table from the data frame
data <- data.table(NEIFiltered)

# sum the total PM2.5 emission from Baltimore City between the years 1999 and 2008
# and for all available sources (point, nonpoint, onroad, nonroad)
baltimoreEmissions <- data[, list(totalPM25BmC=sum(Emissions)), by=list(year, type)]

# plot it with ggplot2 plotting system
png("plot3.png", height=500, width=600)
pp <- ggplot(baltimoreEmissions, aes(x=factor(year), y=totalPM25BmC, fill=type)) +
  geom_bar(stat="identity") +
  facet_wrap(~ type, ncol=2) +
  xlab("year") +
  ylab(expression("Total emission of " ~ PM[2.5])) +
  ggtitle(expression("Emission of " ~ PM[2.5] ~ " in Baltimore City for the four source types")) +
  theme(plot.title = element_text(color="blue", size=16, vjust=1.0))
print(pp)
dev.off()
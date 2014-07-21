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

# filter the data: find all motor vehicles of Baltimore city
NEIFiltered <- dplyr::filter(NEI, (fips=="24510" & type=="ON-ROAD"))
data <- data.table(NEIFiltered)
# sum the total PM2.5 emission for all motor vehicle sources between the years 1999 and 2008
baltimoreEmissionsMV <- data[, list(totalPM25MVBmC=sum(Emissions)), by=year]

# plot it with the ggplot2 plotting system
png("plot5.png")
plottedEmission <- ggplot(baltimoreEmissionsMV, aes(x=factor(year), y=totalPM25MVBmC)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total emission of " ~ PM[2.5])) +
  ggtitle("Baltimore City, emissions of motor vehicle sources") +
  theme(plot.title = element_text(color="blue", size=16, vjust=1.0))
print(plottedEmission)
dev.off()
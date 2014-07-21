library(data.table)
library(dplyr)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

NEI2 <- dplyr::filter(NEI, (fips=="24510" & type=="ON-ROAD"))
data <- data.table(NEI2)

baltimoreEmissionsMV <- data[, list(totalPM25MVBmC=sum(Emissions)), by=year]

png("plot5.png")
plottedEmission <- ggplot(bmore.emissions.aggr, aes(x=factor(year), y=Emissions)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total emission of " ~ PM[2.5])) +
  ggtitle("Baltimore City, emissions of motor vehicle sources") +
  theme(plot.title = element_text(color="blue", size=16, vjust=1.0))
print(plottedEmission)
dev.off()
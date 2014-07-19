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

NEI2 <- filter(NEI, fips=="24510")
data <- data.table(NEI2)

baltimoreEmissions <- data[, list(totalPM25BmC=sum(Emissions)), by=list(year, type)]

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
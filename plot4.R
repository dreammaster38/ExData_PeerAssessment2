library(data.table)
library(plyr)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

coalCombustion <- grep("Coal", SCC$EI.Sector, ignore.case=TRUE)
SCCNew <- SCC[coalCombustion, ]

# join data set for coal with NEI data set, type is inner to get only matchink keys
# in both data frames
joinedSCCCoal <- join(SCCNew, NEI, by="SCC", type="inner")

data <- data.table(joinedSCCCoal)
totalPM25CoalUS <- data[, list(totalPM25=sum(Emissions)), by=year]

png("plot4.png", width=520)
plottedEmission <- ggplot(totalPM25CoalUS, aes(x=factor(year), y=totalPM25)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total emission of " ~ PM[2.5])) +
  ggtitle("Emissions of " ~ PM[2.5] ~ " for coal combustion-related sources") +
  theme(plot.title = element_text(color="blue", size=16, vjust=1.0))
print(plottedEmission)
dev.off()
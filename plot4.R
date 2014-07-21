library(data.table)
library(plyr)
library(ggplot2)

## Load the two data sets if the not already exists in memory
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

# filter the data: find all coal combustion-related sources 
coalCombustion <- grep("Coal", SCC$EI.Sector, ignore.case=TRUE)
SCCNew <- SCC[coalCombustion, ]

# join data set for coal with NEI data set, type is inner to get only matchink keys
# in both data frames
joinedSCCCoal <- join(SCCNew, NEI, by="SCC", type="inner")
data <- data.table(joinedSCCCoal)
# sum the total PM2.5 emission for all US coal combustion-related sources between the years 1999 and 2008
totalPM25CoalUS <- data[, list(totalPM25=sum(Emissions)), by=year]

# plot it with ggplot2 system
png("plot4.png", width=520)
plottedEmission <- ggplot(totalPM25CoalUS, aes(x=factor(year), y=totalPM25)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("Total emission of " ~ PM[2.5])) +
  ggtitle("Emissions of " ~ PM[2.5] ~ " for coal combustion-related sources") +
  theme(plot.title = element_text(color="blue", size=16, vjust=1.0))
print(plottedEmission)
dev.off()
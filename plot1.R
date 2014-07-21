#library(plyr)
library(data.table)

## Load the two data sets if the not already exists in memory
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

# create a data table from the data frame
data <- data.table(NEI)
# sum the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
totalPM25ForYears <- data[, list(totalPM25=sum(Emissions)), by=year]

# plot it with the base plotting system
png("plot1.png")
plot(totalPM25ForYears$year,
     totalPM25ForYears$totalPM25,
     type="l",
     main="Total emission of " ~ PM[2.5] ~ " between 1999 and 2008",
     xlab="year", ylab=expression("Total emission of " ~ PM[2.5] ~ " in tons"))
dev.off()
library(data.table)
library(dplyr)

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
totalPM25Baltimore <- data[, list(totalPM25=sum(Emissions)), by=year]

# plot it with the base plotting system
png("plot2.png")
plot(totalPM25Baltimore$year,
     totalPM25Baltimore$totalPM25,
     type="l",
     main="Total emission of " ~ PM[2.5] ~ " in Baltimore City",
     xlab="year",
     ylab=expression("Total emission of " ~ PM[2.5] ~ " in tons"))
dev.off()
library(data.table)
library(dplyr)

## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

NEI2 <- filter(NEI, fips=="24510")
data <- data.table(NEI2)

totalPM25Baltimore <- data[, list(totalPM25=sum(Emissions)), by=year]

png("plot2.png", width=480, height=480)
plot(totalPM25Baltimore$year,
     totalPM25Baltimore$totalPM25,
     type="l",
     main="Total emission of " ~ PM[2.5] ~ " in Baltimore City",
     xlab="year",
     ylab=expression("Total emission of " ~ PM[2.5] ~ " in tons"))
dev.off()
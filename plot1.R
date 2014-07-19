#library(plyr)
library(data.table)

## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds")
}

data <- data.table(NEI)
totalPM25ForYears <- data[, list(totalPM25=sum(Emissions)), by=year]
#df = ddply(NEI, .(year), summarize, s = sum(Emissions), .parallel=TRUE)

png("plot1.png", width=480, height=480)
plot(totalPM25ForYears$year,
     totalPM25ForYears$totalPM25,
     type="l",
     main="Total emission of " ~ PM[2.5] ~ " between 1999 and 2008",
     xlab="year", ylab=expression("Total emission of " ~ PM[2.5] ~ " in tons"))
dev.off()
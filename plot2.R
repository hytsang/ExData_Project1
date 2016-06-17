# check if a data folder exists; if not then create one
if (!file.exists("data")) {dir.create("data")}

# file URL & destination file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile <-"./data/power_consumption.zip"

# download the file & note the time
download.file(fileUrl, destfile)
unzip(zipfile="./data/power_consumption.zip", exdir="./data")
dateDownloaded <- date()
filePath<-"./data/household_power_consumption.txt"

# set the file to read
d <- file(filePath, "r");

# read in the data until date
DataHousehold <- read.table(text = grep("^[1,2]/2/2007", readLines(d), value = TRUE), 
                            sep = ";", skip = 0, na.strings = "?", stringsAsFactors = FALSE)

# rename the columns
names(DataHousehold) <- c("date", "time", "active_power", "reactive_power", "voltage",
                          "intensity", "sub_metering_1", "sub_metering_2", 
                          "sub_metering_3")

# add a new date-time formated column
DataHousehold$new_time <- as.POSIXct(paste(DataHousehold$date, DataHousehold$time), format = "%d/%m/%Y %T")

# plot 2 - line graph
par(mfrow = c(1, 1))
plot(DataHousehold$new_time, DataHousehold$active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)" )

# copy plot to png file
dev.copy(png, file = "plot2.png")

# close connection to png device
dev.off()
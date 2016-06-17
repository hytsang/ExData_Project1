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

# plot 3 - sub metering
par(mfrow = c(1, 1))
with(DataHousehold, {
  plot(new_time, sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(new_time, sub_metering_2, col = "red")
  lines(new_time, sub_metering_3, col = "blue")
  legend("topright", col = c("black", "red", "blue"), cex = 0.8, lty = 1,
         legend = c("Sub_metering_1    ", 
                    "Sub_metering_2    ",
                    "Sub_metering_3    "))
  
})
# copy plot to png file
dev.copy(png, file = "plot3.png")

# close connection to png device
dev.off()
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

# plot 4
par(mfrow = c(2, 2))
with(DataHousehold, {
  plot(new_time, active_power, type = "l", xlab = "", ylab = "Global Active Power")
  plot(new_time, voltage, type = "l", xlab = "datetime", ylab = "Voltage")
  plot(new_time, sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(new_time, sub_metering_2, col = "red")
  lines(new_time, sub_metering_3, col = "blue")
  legend("topright", col = c("black", "red", "blue"), cex = 0.7, lty = 1, bty = "n",
         legend = c("Sub_metering_1", 
                    "Sub_metering_2",
                    "Sub_metering_3"))
  plot(new_time, reactive_power, type = "l", xlab = "datetime", ylab = "Global Reactive Power")
})

# copy plot to png file
dev.copy(png, file = "plot4.png")

# close connection to png device
dev.off()
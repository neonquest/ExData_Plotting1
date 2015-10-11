url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("data")) {dir.create("./data")}

power_consumption_file = "./household_power_consumption.txt" 

if (!file.exists(power_consumption_file)) {
    data_file = "./data/household_power_consumption.zip"
    download.file(url, destfile = data_file, method = "curl")
    
    unzip(data_file)
}

# $ grep -n "^1/2/2007" household_power_consumption.txt  | head -1
# 66638:1/2/2007;00:00:00;0.326;0.128;243.150;1.400;0.000;0.000;0.000
# $ grep -n "^2/2/2007" household_power_consumption.txt  | tail -1
# 69517:2/2/2007;23:59:00;3.680;0.224;240.370;15.200;0.000;2.000;18.000

num_rows = 2*24*60
header = read.csv(power_consumption_file, sep = ";", nrows = 1)
data   = read.csv(power_consumption_file, sep = ";", header = FALSE, skip = 66637, 
                  nrows = num_rows, na.strings = "?")

names(data) = names(header)

data$DateTime = as.POSIXct(paste(data$Date, data$Time, sep = " "),
                           format = "%d/%m/%Y %H:%M:%S")

png(filename = "plot3.png", width = 480, height = 480)
plot(data$DateTime, data$Sub_metering_1, type = "l", col = "black",
     main = "", xlab = "", ylab = "Energy sub metering")
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
legend("topright", lwd = 1, lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
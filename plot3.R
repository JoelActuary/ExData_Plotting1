## These scripts are for plotting graphs on household power consumption data from the below URL:
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## The graph plotted is specifically with respect to observations on February 1-2, 2007.

## Read in data from locally saved, unzipped file, and load required packages

data_100 <- read.table("./household_power_consumption.txt", sep=";", nrows = 100000, header = TRUE, colClasses = "character")
library(dplyr)
library(tidyr)
library(lubridate)

## Subset data and format columns to acquire clean data only for Feb 1-2, 2007.

day1 <- as.Date("2007-02-01")
day2 <- as.Date("2007-02-02")

data_df <- tbl_df(data_100) %>%
        mutate(Date_Time = paste(Date, Time, sep =" ")) %>%
        mutate(Date = as.Date(dmy(Date))) %>%
        filter(Date == day1|Date == day2) %>%
        mutate(Global_active_power = as.numeric(Global_active_power)) %>%
        mutate(Global_reactive_power = as.numeric(Global_reactive_power)) %>%
        mutate(Voltage = as.numeric(Voltage)) %>%
        mutate(Global_intensity = as.numeric(Global_intensity)) %>%
        mutate(Sub_metering_1 = as.numeric(Sub_metering_1)) %>%
        mutate(Sub_metering_2 = as.numeric(Sub_metering_2)) %>%
        mutate(Sub_metering_3 = as.numeric(Sub_metering_3))

## Data frame with just date_time and submeter data
plot_data <- data.frame(strptime(data_df$Date_Time,"%d/%m/%Y %H:%M:%S"),
                        data_df$Sub_metering_1,
                        data_df$Sub_metering_2,
                        data_df$Sub_metering_3)
colnames(plot_data) <- c("Date_Time", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

## Plot 3 line graphs of date_time (x) vs submeter 1/2/3 data (y)

# Open PNG device, "plt1.png" in working directory.
png(file = "plot3.png")

# Create and annotate plot
par(mar=c(5,5,4,3))
plot(x = plot_data$Date_Time, y = plot_data$Sub_metering_1, 
     type = "l", 
     ylab = "Energy sub metering", 
     xlab = "",
     cex.axis = 0.75,
     cex.lab = 0.75)
lines(x = plot_data$Date_Time, y = plot_data$Sub_metering_2, col = "red")
lines(x = plot_data$Date_Time, y = plot_data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = 1, col = c(1, "red", "blue"), bty = "o", cex = 0.75)

# Close PNG file device
dev.off()

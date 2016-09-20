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

## Data frame with date_time, global active & reactive power, submeter 1/2/3 and voltage data
plot_data <- data.frame(strptime(data_df$Date_Time,"%d/%m/%Y %H:%M:%S"),
                        data_df$Sub_metering_1,
                        data_df$Sub_metering_2,
                        data_df$Sub_metering_3,
                        data_df$Global_active_power,
                        data_df$Global_reactive_power,
                        data_df$Voltage)
colnames(plot_data) <- c("Date_Time", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3", "Global_Active_Power", 
                         "Global_Reactive_Power", "Voltage")

## Plot 4 graphs of date-time (x) versus 
## (i) Global Active Power, 
## (ii) Voltage,
## (iii) sub meter 1/2/3 data, and 
## (iv) Global Reactive Power

# Open PNG device, "plt1.png" in working directory.
png(file = "plot4.png")

# Create and annotate plot
par(mfrow = c(2,2))
par(mar=c(4,4,3,2))
with(plot_data,{
        # (i) Global Active Power
        plot(x = Date_Time, y = Global_Active_Power,
             type = "l",
             ylab = "Global Active Power",
             xlab = "",
             cex.axis = 0.75,
             cex.lab = 0.75)
        
        # (ii) Voltage
        plot(x = Date_Time, y = Voltage,
             type = "l",
             xlab = "datetime",
             ylab = "Voltage",
             cex.axis = 0.75,
             cex.lab = 0.75)
        
        # (iii) sub meter 1/2/3 data
        plot(x = Date_Time, y = Sub_metering_1, 
             type = "l", 
             xlab = "", 
             ylab = "Energy sub metering",
             cex.axis = 0.75,
             cex.lab = 0.75)
        lines(x = Date_Time, y = Sub_metering_2, col = "red")
        lines(x = Date_Time, y = Sub_metering_3, col = "blue")
        legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = 1, col = c(1, "red", "blue"), bty = "n", cex = 0.75)

        # (iv) Global Reactive Power
        plot(x = Date_Time, y = Global_Reactive_Power,
             type = "l",
             xlab = "datetime",
             cex.axis = 0.5,
             cex.lab = 0.75)
})

# Close PNG file device
dev.off()

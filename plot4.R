## Load Packages
library(sqldf)
library(reshape)

## Calculating a rough estimate of file size
if (0) {
  # Using ASCII coding, 1 character = 1 byte
  byte_per_char <- 1
  # I estimate roughly 8 characters per data point 
  # (date = mm/dd/yyyy, time = hh:mm:ss for example)
  char_per_column <- 8
  cols <- 9
  rows <- 2075259
  # Therefore estimate of file size 
  fsize <- byte_per_char * char_per_column * cols * rows
  fsize
  # In MBs
  fsize / 1000000
}

## Downloading and loading data
if (1) {
  # Download and unzip the dataset:
  filename <- "exdata_household_power_consumption.zip"
  
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, filename, mode = "wb")
    unzip(filename) 
  }  
  # Loading data 
  fp_data  <- "household_power_consumption.txt"
  file_conn <- file(fp_data)
  df_data <- sqldf("select *
                 from file_conn
                 where Date in ('1/2/2007','2/2/2007')" ,
                   file.format = list(header = TRUE, sep = ";",
                                      colClasses = c("character","character","numeric","numeric",
                                                     "numeric","numeric","numeric","numeric",
                                                     "numeric"),
                                      na.strings=c("?","NA")))
  close(file_conn)
  df_data$Date_Time <- paste(df_data$Date," ",df_data$Time)
  df_data$Date_Time <- strptime(df_data$Date_Time,format = '%d/%m/%Y  %X')
  df_data$Date <- as.Date(df_data$Date,format = '%d/%m/%Y')
  #str(df_data)
  
}

## Plot 4
png("plot4.png",width=480,height=480,units="px")
par(mfcol = c(2,2),mar=c(2,4,1,1))
with(df_data,plot(Date_Time,Global_active_power,type="o",pch=26,
                  ylab="Global Act. Power (kw)",xlab="Time"))

with(sub_metering, plot(Date_Time,energy_sub_metering,type="n",xlab="Date",ylab="Energy sub metering"))
with(subset(sub_metering,Meter=="Sub_metering_1"),
     lines(Date_Time,energy_sub_metering,col="purple",pch=26,type="o",lty=1))
with(subset(sub_metering,Meter=="Sub_metering_2"),
     lines(Date_Time,energy_sub_metering,col="red",pch=26,type="o",lty=2))
with(subset(sub_metering,Meter=="Sub_metering_3"),
     lines(Date_Time,energy_sub_metering,col="blue",pch=26,type="o",lty=3))
legend("topright",legend=c("Meter 1","Meter 2","Meter 3"),col=c("purple","red","blue"),lty=1:3,cex=0.8)

with(df_data, plot(Date_Time,Voltage,type="o",pch=26,
                   ylab="Voltage",xlab="Time"))
with(df_data, plot(Date_Time,Global_reactive_power,type="o",pch=26,
                   ylab="Global React. Power (kw)",xlab="Time"))
dev.off()


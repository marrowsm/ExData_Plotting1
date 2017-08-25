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

# Plot 1
png("plot1.png",width=480,height=480,units="px")
with(df_data,hist(Global_active_power, xlab ="Global Active Power (kilowatts)",
                  col="red",main="Global Active Power",ylim=c(0,1200)))
dev.off()

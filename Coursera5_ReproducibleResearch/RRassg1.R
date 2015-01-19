# Load and format the data

### Set your working directory
setwd("~/RepData_PeerAssessment1")
### Unzip the compressed file in this directory
unzip("activity.zip", "activity.csv")
### Read the CSV file into R
activity <- read.csv("activity.csv")
### Check structure of the data
str(activity)
### Count NA's in the data
sum(is.na(activity$steps))
sum(is.na(activity$date))
sum(is.na(activity$interval))
### Note the issue that certain days include only NA values
nrow(activity[activity$date=="2012-10-01",])
sum(is.na(activity[activity$date=="2012-10-01",]))
### Format date column as date
activity$date <- as.Date(activity$date, "%Y-%m-%d")
### Save interval column into hours and minutes columns
interval <- unique(activity$interval)
hour <- vector(mode="character", length=length(interval))
minute <- vector(mode="character", length=length(interval))
for(i in 1:length(interval)) {
  for(h in 23:0) {
  if(interval[i] < h*100+100) {
    hour[i] <- as.character(h)
    minute[i] <- as.character(interval[i] - h*100)
  }
  }
}
### Join hours and minutes columns, adding a zero if minutes less than 10
minute[minute=="0"] <- "00"
minute[minute=="5"] <- "05"
time <- paste(hour, minute, sep=":")
### Merge new time column (as factor) to the activity dataset
time.interval <- data.frame(interval, time)
activity <- merge(activity, time.interval)

# What is mean total number of steps taken per day?

### 1. Make a histogram of the total number of steps taken each day
#### Note: NA values are included so that days with only NA are not summed as zero.
sum.daily <- tapply(activity$steps, activity$date, sum, na.rm=FALSE)
hist(sum.daily, main="Total steps taken per day", xlab="Number of Steps", 
     breaks=10, col="gold", ylim=c(0,20), xlim=c(0,25000), cex.axis=.85)

### 2. Calculate and report the mean and median total number of steps taken per day
#### Note: NA's are now excluded, allowing us to take the mean of only non-NA records.
mean(sum.daily, na.rm=TRUE)
median(sum.daily, na.rm=TRUE)

# What is the average daily activity pattern?

### 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) 
### and the average number of steps taken, averaged across all days (y-axis)

mean.byinterval <- tapply(activity$steps, activity$interval, mean, na.rm=TRUE)
plot(names(mean.byinterval), mean.byinterval, type="l", main="Average steps throughout the day",
     xlab="Time of Day", ylab="Number of Steps", axes=FALSE, lwd=2, col="purple4")
axis(2, cex.axis=.85, col.axis="seagreen")
hourly <- seq(1, by=48, length.out=6)
hourly[7] <- 288
axis(1, cex.axis=.85, at=names(mean.byinterval)[hourly], labels=time[hourly], col.axis="seagreen")

### 2. Which 5-minute interval, on average across all the days in the dataset, 
### contains the maximum number of steps?
#### We have a matching vector of pretty times equal to the times of the intervals.
#### Here we search the time entry that aligns with the interval entry containing the maximum
#### of average number of steps.
time[mean.byinterval==max(mean.byinterval)]

# Imputing missing values

### 1. Calculate and report the total number of missing values in the dataset
### (i.e. the total number of rows with NAs)

sum(is.na(activity$steps))
sum(is.na(activity$date))
sum(is.na(activity$interval))

### 2. Devise a strategy for filling in all of the missing values in the dataset. 
### The strategy does not need to be sophisticated. For example, you could use 
### the mean/median for that day, or the mean for that 5-minute interval, etc.

#### We choose to impute missing values by filling with the median number of steps
#### for the 5-minute interval. This preserves the daily activity pattern and, for
#### days with only NA's, estimates the total steps per day. Median rather than mean
#### avoids skewing our imputed value if there are some intervals with extreme values.

### 3. Create a new dataset that is equal to the original dataset but with the 
### missing data filled in.

#### Save new dataset so we don't overwrite the old one
activity2 <- activity

#### Calculate the set of medians by interval
median.byinterval <- tapply(activity2$steps, activity2$interval, median, na.rm=TRUE)

#### Fill NAs by looping through the 288 intervals
for(i in 1:length(median.byinterval)) {
  j <- unique(activity2$interval)[i]
  activity2[activity2$interval==j & is.na(activity2$steps),2] <- median.byinterval[i]
}

### 4. Make a histogram of the total number of steps taken each day. 
### Calculate and report the mean and median total number of steps taken per day. 
### Do these values differ from the estimates from the first part of the assignment? 
### What is the impact of imputing missing data on the estimates of the total daily number of steps?

#### Make the histogram
sum.daily2 <- tapply(activity2$steps, activity2$date, sum)
hist(sum.daily2, main="Total steps taken per day (imputed)", xlab="Number of Steps", 
     breaks=10, col="olivedrab1", ylim=c(0,20), xlim=c(0,25000), cex.axis=.85)

#### Mean and median total steps per day
#### After imputing:
mean(sum.daily2)
median(sum.daily2)
#### Before imputing:
mean(sum.daily, na.rm=TRUE)
median(sum.daily, na.rm=TRUE)

#### Yes, the mean and median total steps taken per day differ after imputation.
#### After imputation, the mean has decreased by 1262 steps, and the median has decreased
#### by 370 steps. The imputed values for steps are lower than the non-NA values in terms
#### of the total steps. Total daily number of steps appears lower after imputation.

# Are there differences in activity patterns between weekdays and weekends?

### 1. Create a new factor variable in the dataset with two levels – 
### “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

weekend <- ("Saturday" == weekdays(activity$date)) + ("Sunday" == weekdays(activity$date))
weekend[weekend==1] <- "weekend"
weekend[weekend=="0"] <- "weekday"
weekend <- as.factor(weekend)
activity2 <- data.frame(activity2, weekend)
str(activity2)

### 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute 
### interval (x-axis) and the average number of steps taken, averaged across all weekday days 
### or weekend days (y-axis). See the README file in the GitHub repository to see an example 
### of what this plot should look like using simulated data.

#### Separate weekend and weekday datasets
act.weekend <- activity2[activity2$weekend=="weekend",]
act.weekday <- activity2[activity2$weekend=="weekday",]

#### Calculate average number of steps taken daily
mean.weekend <- tapply(act.weekend$steps, act.weekend$interval, mean)
mean.weekday <- tapply(act.weekday$steps, act.weekday$interval, mean)

#### Create graphs
par(mfrow=c(2,1), xpd=NA, mar=c(0,0,2,0), oma=c(5,4,3,1), cex.axis=0.7)

plot(names(mean.weekend), mean.weekend, type="l", ylim=c(0,200),
     xlab=" ", ylab=" ", axes=FALSE, lwd=2, col="orangered")
title(main="Weekend Days", cex.main=1, line=0.5, col.main="purple4")
axis(2, col.axis="springgreen4")
hourly <- seq(1, by=48, length.out=6)
hourly[7] <- 288
axis(1, at=names(mean.weekend)[hourly], labels=time[hourly], col.axis="white")

plot(names(mean.weekday), mean.weekday, type="l", ylim=c(0,200),
     xlab=" ", ylab=" ", axes=FALSE, lwd=2, col="orangered")
title(main="Weekdays", cex.main=1, line=0, col.main="purple4")
axis(2, col.axis="springgreen4")
hourly <- seq(1, by=48, length.out=6)
hourly[7] <- 288
axis(1, at=names(mean.weekday)[hourly], labels=time[hourly], col.axis="springgreen4")

title(main="Average steps throughout the day", xlab="Time of Day", ylab="Number of Steps",
      outer=TRUE)




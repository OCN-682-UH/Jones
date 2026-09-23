## This code is for learning how to use joins and lubridate in class
##
## Created by: Ellie S Jones
## Created on: 2026-09-22
## Last updated: 2026-09-22
####################################################################

## Load libraries
library(tidyverse)
library(here)

## Load data
SiteData <- read_csv(here("Week_05","Data","site.characteristics.data.csv"))
view(SiteData)
DataDictionary <- read_csv(here("Week_05","Data","data_dictionary.csv"))
view(DataDictionary)
ThermalData <- read_csv(here("Week_05","Data","Topt_data.csv"))
View(ThermalData)

## Create sample tibbles/two small example datasets
T1 <- tibble(Site.ID = c("A","B","C","D"),
             Temperature = c(14.1,16.7,15.3,12.8))
T1
T2 <- tibble(Site.ID = c("A", "B", "D", "E"),
             pH = c(7.3, 7.8, 8.1, 7.9))
T2

## Practice with joins
left_join(T1,T2)
right_join(T1,T2)
inner_join(T1,T2)
full_join(T1,T2)
semi_join(T1,T2)
anti_join(T1,T2)

## Practice with dates and times in lubridate
now()                # Gives current time in current time zone
now(tzone="EST")
today()              # Gives date in a specific timezone
today(tzone="GMT")
am(now())            # Is it morning? Returns TRUE or FALSE
leap_year(now())     # Is it a leap year? Returns TRUE or FALSE
ymd("2021-02-24")
mdy("02/24/2021")
mdy("February 24 2021")
dmy("24/02/2021")                  # Convert all forms of dates to YMD, which is correct format to state a date
ymd_hms("2021-02-24 10:22:20 PM")
mdy_hms("02/24/2021 22:22:20")
mdy_hm("February 24 2021 10:22 PM")     # Convert dates and times
datetimes <- c("02/24/2021 22:22:20",
               "02/25/2021 11:21:20",
               "02/26/2021 8:01:52")    # Create a vector of datetimes
datetimes
datetimes <- mdy_hms(datetimes)     # Convert entire vector to datetime objects
datetimes
month(datetimes)                       # Extract the month as a number
month(datetimes,label=TRUE)            # Extract the month as an abbreviated label
month(datetimes,label=TRUE,abbr=FALSE) # Extract the month as a full name
day(datetimes)                         # Extract the day of the month
wday(datetimes,label=TRUE)             # Extract the day of the week
hour(datetimes)
minute(datetimes)
second(datetimes)               # Extract hour, minute, and second
datetimes + hours(4)            # Adding time intervals - "hour" extracts the hour component while "hours" adds hours to a datetime
datetimes + days(2)             # Adding time intervals - you can also add minutes(), seconds(), months(), years()
round_date(datetimes,"minute")  # Rounding dates to the nearest minute

# Create a datetime WITHOUT timezone info
datetime_naive <- mdy_hms("02/24/2021 10:22:20")
datetime_naive
# Assume the naive time is in Hawaii
hawaii_time <- with_tz(datetime_naive, tzone = "US/Hawaii")
hawaii_time
# Same moment, viewed from EST
est_time <- with_tz(hawaii_time, tzone = "EST")
est_time       # Instant in time is the same, just being viewed in different time zones
# Claim this was collected in Hawaii (though it was naive)
force_hawaii <- force_tz(datetime_naive, tzone = "US/Hawaii")
force_hawaii
# Now convert to EST (this changes the clock time!)
with_tz(force_hawaii, tzone = "EST")

## Read in the conductivity data and convert the date column to a datetime
CondData <- read_csv(here("Week_05","Data","CondData.csv"))
View(CondData)
CondData |>
  mutate(datetime = mdy_hms(date))

## Combine thermal data and site data
View(SiteData)
View(ThermalData)
full_join(SiteData,ThermalData,by="site.letter")
wide_SiteData <- SiteData |>
  pivot_wider(names_from = "parameter.measured",
              values_from = "values")
glimpse(wide_SiteData)
joined_files <- full_join(wide_SiteData,ThermalData)
view(joined_files)

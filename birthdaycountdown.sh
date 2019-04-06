#!/usr/bin/env bash

#Greet the user by figuring out their user name (who)
#Ask the user to input their birthday (day, month, in integers)
#Calculate and display the number of days to their birthday

function isLeap(){
    checkYear=$1 #year to check
    (( !(checkYear % 4) && ( checkYear % 100 || !(checkYear % 400) ) )) &&
      return 1 || return 0
}

name=($(who))
birthMonth=1
birthday=1

#extract the integers from todays date to use in comparison
today=$(date +%d)
thisMonth=$(date +%m)
thisYear=$(date +%Y)

nextYear=$thisYear #initialize nextyear as this year, to increment if needed
daysToBirthday=0

echo "Hello $name"
echo "Enter the month you were born (int): "

read birthMonth

echo "Enter the day you were born (int): "

read birthday

#check if today is the user's birthday, exit if so
if [[ birthMonth -eq thisMonth ]] && [[ birthday -eq today ]]
then
    echo "Happy Birthday!"
    exit 0
fi

#check if the user's birthday is a leap day, account for the years
if [[ $birthMonth -eq 2 ]] && [[ $birthday -eq 28 ]]
then
    if [[ $birthMonth -lt $thisMonth ]] || ( [[ $today -le $birthday  ]] && [[ $birthMonth -ge $thisMonth ]] )
    then
        let "nextYear += 1"
    fi
    #loop increments the "next year" progressively until it finds the next leap year with a 28th of Feb
    isLeap $nextYear
    while [[ $? -ne 1 ]]
    do
        let "nextYear += 1"
        isLeap $nextYear
    done
    
else #birthday not leap day
    if [[ $birthMonth -lt $thisMonth ]] || ( [[ $birthday -le $today  ]] && [[ $birthMonth -ge $thisMonth ]] )
    then
        let "nextYear += 1"
    fi
fi

#create a date variable with the user's input (and corrected year) 
# convert it to seconds since epoch
newDate=$(date --date="$birthMonth/$birthday/$nextYear" +%s)

#get current time in seconds since epoch
now=$(date +%s)

#compare the dates by subtracting todays seconds since epoch from the future birthday
#and convert the resulting seconds to days
let "daysToBirthday = ($newDate - $now)/(24 * 3600)"

#accounting for a small discrepency when the user's birthday is tomorrow
# which would be 0.0000-0.99999etc days away, which is represented as 0 (int)
if [[ $daysToBirthday -eq 0 ]]
then
    daysToBirthday=1
    # Note that this correction is okay, because if today is the user's birthday,
    #it's accounted for at the beginning of the script
fi

echo "There are $daysToBirthday days until your birthday."

exit 0

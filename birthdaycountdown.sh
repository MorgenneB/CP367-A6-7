#!/usr/bin/env bash

#Greet the user by figuring out their user name (who)
#Ask the user to input their birthday (day, month, in integers)
#Calculate and display the number of days to their birthday

function isLeap(){
    checkYear=$1 #year to check
    (( !(checkYear % 4) && ( checkYear % 100 || !(checkYear % 400) ) )) &&
    return 1 || return 0
}

#Feature 4: Loop through until user stops the script
while true
do
    
    name=($(who))
    birthMonth=1
    birthday=1

    #extract the integers from todays date to use in comparison
    today=$(date +%d)
    thisMonth=$(date +%m)
    thisYear=$(date +%Y)

    #Feature 2:
    #Using command line argument, the user can enter an offset (the number of days)
    #from the current date in the positive direction by at most 15 years. 
    if [[ $# == 1 ]]
    then
        offset=$1
        #max offset is 15 years, offset must be positive
        let MAX_OFFSET=15*365
        if [[ $offset -lt 0 ]] || [[ $offset -gt $MAX_OFFSET ]]
        then
            echo "Offset invalid, must be in the range of 0-15 years."
            echo "Continuing without offset"
            offset=0
        else
            #update current date to offset date
            today=$(date +%d -d "$offset days")
            thisMonth=$(date +%m -d "$offset days")
            thisYear=$(date +%Y -d "$offset days")
            
            #Feature 3:
            #If the offset date brings us to a special holiday,
            #also give a festive message
            if [[ thisMonth -eq 10 ]] && [[ today -eq 31 ]]
            then
		echo "How spooky!"
            elif [[ thisMonth -eq 12 ]] && [[ today -eq 25 ]]
            then
		echo "Check under the Christmas tree!"
            elif [[ thisMonth -eq 3 ]] && [[ today -eq 17 ]]
            then
		echo "It's time to wear green!"
            elif [[ thisMonth -eq 7 ]] && [[ today -eq 1 ]]
            then
		echo "Listen to those fireworks!"
            fi
            echo "Offset by $offset days, the date is $(date -d "$offset days")"
        fi
    fi

    nextYear=$thisYear #initialize nextyear as this year, to increment if needed
    daysToBirthday=0

    echo "Hello $name"
    echo "Enter the month you were born (int): "

    read birthMonth

    echo "Enter the day you were born (int): "

    read birthday

    echo "Enter the year you were born (int):"

    read birthYear

    #check if the user's birthday is a leap day, account for the years
    if [[ $birthMonth -eq 2 ]] && [[ $birthday -eq 29 ]]
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
    now=$(date --date="$thisMonth/$today/$thisYear" +%s)

    #compare the dates by subtracting todays seconds since epoch from the future birthday
    #and convert the resulting seconds to days
    let "daysToBirthday = ($newDate - $now)/(24 * 3600)"
    
    #Feature 5: Determines age
    if [[ $thisMonth -lt $birthMonth ]] || [[ $thisMonth -eq $birthMonth && $today -lt $birthday ]]
    then
        let "age = ($thisYear-$birthYear-1)"
    else
        let "age = ($thisYear-$birthYear)"
    fi

    #Feature 1:
    #If the current date is the user's birthday, print "Happy Birthday!"
    #Also print messages for Halloween, Christmas, St.Patrick's day, and Canada day
    if [[ birthMonth -eq thisMonth ]] && [[ birthday -eq today ]]
    then
        #Feature 3:
        #Check if the user’s birthday is one of the special holiday’s listed above.
        #If so, provide a special festive birthday message to the user.
        if [[ thisMonth -eq 10 ]] && [[ today -eq 31 ]]
        then
            echo "Happy BOOthday!"
            echo "You are $age years old!"
        elif [[ thisMonth -eq 12 ]] && [[ today -eq 25 ]]
        then
            echo "Ho ho ho, Merry Birthday!"
            echo "You are $age years old!"
        elif [[ thisMonth -eq 3 ]] && [[ today -eq 17 ]]
        then
            echo "It's your birthday AND St. Patrick's Day? Have fun but stay safe!"
            echo "You are $age years old!"
        elif [[ thisMonth -eq 7 ]] && [[ today -eq 1 ]]
        then
            echo "Have a Happy Canadian Birthday!"
            echo "You are $age years old!"
        else
            echo "Happy Birthday!"
            echo "You are $age years old!"
        fi
    else
	if [[ thisMonth -eq 10 ]] && [[ today -eq 31 ]]
	then
            echo "Have a spooky HalloweEeEEen!"
	elif [[ thisMonth -eq 12 ]] && [[ today -eq 25 ]]
	then
            echo "Merry Christmas!"
	elif [[ thisMonth -eq 3 ]] && [[ today -eq 17 ]]
	then
            echo "Don't get too drunk! It's St.Patrick's Day!"
	elif [[ thisMonth -eq 7 ]] && [[ today -eq 1 ]]
	then
            echo "Happy Canada Day!"
	fi
	echo "There are $daysToBirthday days until your birthday."
    fi

    echo "Enter any key to continue or n to stop"
    read ans

    if [[ $ans == "n" ]]
    then
	break
    fi
done
exit 0

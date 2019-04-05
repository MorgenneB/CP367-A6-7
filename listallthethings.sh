#!/usr/bin/env bash
#Recursively iterates through subdirectories, printing the ls -l result
#of any file that matches a user argument
find_files() {
    for file in $PWD/*
    do
        #if regular file, determine if it matches any user arguments
        if [ -f $file ]
        then
            for arg in $@
            do
                echo $file | grep -q /$arg$
                if [ $? == 0 ]
                then
                    #we only want the ls -l for the exact filename
                    ls -i | grep " $arg$"
                fi
            done
        #if directory is found, change to this directory to search
        elif [ -d $file ]
        then
            cd $file
            find_files $@
            cd ..
        fi
    done
    return 0
}

echo Searching for files...
find_files $@
echo Search complete!
exit 0

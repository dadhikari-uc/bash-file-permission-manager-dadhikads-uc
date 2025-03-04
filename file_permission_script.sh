#!/bin/bash

# Function to display the script usage/help information
# -p, -o, -g are optional arguments and not required
function display_usage() {
    echo "Usage: $0 -f <filename> [-p <permission>] [-o <owner>] [-g <group>]"
    echo "Options:"
    echo "      -f <filename>: Specify the input filename."
    echo "      -p <permission>: Specify the the file permission to set."
    echo "      -o <owner>: Specify who owns the file."
    echo "      -g <group>: Specify the file group."
    echo "      -h: Display this help information."
}

# If no argument is provided or -h then display the usage information
if [[ $# -eq 0 || "$1" == -h ]]; then
    display_usage
    exit 0
fi

# Initializing the variables
filename=""
permission=""
owner=""
group=""

# Processing command-line options and arguments
while getopts ":f:p:o:g:h" opt; do
    case $opt in 
        f) # option f
        filename=$OPTARG
        ;;
        p) # option p
        permission=$OPTARG
        ;;
        o) # option o
        owner=$OPTARG
        ;;
        g) # group g
        group=$OPTARG
        ;;
        h) # option h
        # display usage and exit
        display_usage
        exit 0
        ;;
        \?) # any other option
            echo "Invalid option: -$OPTARG"
            # display usage and exit
            display_usage
            exit 1
            ;;
        :) # no argument
            echo "Option -$OPTARG requires an argument."
            # display usage and exit
            display_usage
            exit 1
            ;;
    esac
done

# Check if the filename is provided (filename is the only argument required to run the program)
if [[ -z "$filename" ]]; then
    echo "Error: Missing filename option from argument."
    display_usage
    exit 1
fi

# Check if the filename exist and is a regular file not requiring weird access control
if [[ ! -f $filename ]]; then
    echo "Error: Input file '$filename' does not exist or is not a regular file."
    exit 1
fi

# Perform the select actions based on the users input
if [ -n "$permission" ]; then
    if [[ "$permission" =~ ^[0-7]{3,4}$ ]]; then
        sudo chmod "$permission" "$filename"
        echo "Changed permission of '$filename' to $permission."
    else
        echo "Error: Permission format is incorrect. Please use numbers 3 numbers between 0-7 (e.g. 755 or 660)."
        exit 1
    fi
fi

# Change file owner 
if [ -n "$owner" ]; then
    sudo chown "$owner" "$filename"
    echo "Changed owner of '$filename' to $owner." 
fi

# Change file group 
if [ -n "$group" ]; then
    sudo chgrp "$group" "$filename"
    echo "Changed group access of '$filename' to $group."
fi

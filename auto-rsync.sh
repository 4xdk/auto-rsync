#!/bin/bash

function show_help {
	echo "Usage: auto-rsync.sh -d backup-destination -i folder-list.txt"
}

# A POSIX variable
OPTIND=1

# Process parameters
while getopts "h?vi:d:o:r" opt; do
    case "$opt" in
		d)  DESTINATION=$OPTARG
    		;;
		#o)  OUTPUT_FILE=$OPTARG
        #	;;
    	h)	show_help
        	exit 0
        	;;
		i)  INPUT=$OPTARG
			;;
		r)  REMOVE=1
			;;
		v)  VERBOSE=1
        	;;
		\?) echo "Invalid option" >&2
			;;
    esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

# check if provided input and destination exist
if [ -z $DESTINATION ] || [ ! -d $DESTINATION ]; then
	echo "Backup location not found, exiting"
	show_help
	exit 1
fi

if [ -z $INPUT ] || [ ! -f $INPUT ]; then
    echo "File $INPUT not found, exiting"
	show_help
    exit 1
fi

# adjust rsync parameters
PARAMS='--progress --times --recursive'
if [ $REMOVE ]; then
	PARAMS="--delete $PARAMS"
fi

#if [ ! -z $OUTPUT_FILE ]; then
#	OUTPUT_PARAM="1>>$OUTPUT_FILE 2>>$OUTPUT_FILE.errors"
#fi

function run_backup {
	echo "using $INPUT file to backup to $DESTINATION"
		
	while read DIR
	do
		FOLDER=$( rev <<< $DIR | cut -d/ -f2 | rev )
		echo Copying "$DIR" to "$DESTINATION$FOLDER"
		rsync $PARAMS "$DIR" "$DESTINATION$FOLDER" -q 
	done < $INPUT
}

run_backup 


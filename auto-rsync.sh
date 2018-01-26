#!/bin/bash

function runBackup {
	if [ $# -eq 2 ]; then
		if [ -d $1 ]; then
			local loc_DST=$1
		else
        	echo "Backup location $1 not found, exiting"
			showHelp
			exit 1
		fi
		
	    if [ -f $2 ]; then
            local loc_SRCLIST=$2            
        else
            echo "File $2 not found, exiting"
			showHelp
            exit 1
        fi

		# TODO add confirmation/choice for potentially destructive --delete
		while read DIR
		do
			echo Copying "$DIR" to "$loc_DST"
        	rsync --delete --progress --times --recursive "$DIR" "$loc_DST"  
		done < $loc_SRCLIST
	else
		echo "Missing argument(s)"
		showHelp
		exit 1
	fi
}

function showHelp {
	echo "Usage: auto-rsync.sh backup-destination folder-list.txt"
}

runBackup


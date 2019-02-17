#!/bin/bash
configFile=$1

mainMenu() {
	# creates checklist, returns list of selections
    options=$(whiptail --title "Languages" --checklist \
"Select languages you would like to configure" 15 60 4 \
"C++" "" OFF \
"Python" "" OFF \
"Javascript" "" OFF \
"Java" "" OFF 3<&1 1<&2 2<&3)

    exitstatus=$?

	# TODO currently just loops through and prints selections
    for i in $options
    do
		bash langs/"${i//\"}".sh
    done
}

mainMenu

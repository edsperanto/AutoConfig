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
	
	#TODO THIS IS ALWAYS ZERO
    exitstatus=$?

	# loops through selections and calls those language scripts in 
	# lang/ folder
    for i in $options
    do
		# creates & calls script path from selection 
		# i.e. "C++" --> langs/C++.sh
		bash langs/"${i//\"}".sh
    done
}

mainMenu

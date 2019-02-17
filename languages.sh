#!/bin/bash
source helpers.sh
configFile=$1

getStatuses() {
	if [ $(valueOf "language.cpp.use" "$configFile") ]; then 
		statuses[0]="ENABLED"
	fi

	if [ $(valueOf "language.python.use" "$configFile") ]; then 
		statuses[1]="ENABLED"
	fi

	if [ $(valueOf "language.nodejs.use" "$configFile") ]; then 
		statuses[2]="ENABLED"
	fi

	if [ $(valueOf "language.java.use" "$configFile") ]; then 
		statuses[3]="ENABLED"
	fi
}

languagesMenu() {
	getStatuses

	# creates checklist, returns list of selections
    options=$(whiptail --title "Languages" --menu \
"Configure languages" 15 60 4 \
"C++" "  ${statuses[0]}" \
"Python" "  ${statuses[1]}" \
"Javascript" "  ${statuses[2]}" \
"Java" "  ${statuses[3]}" 3<&1 1<&2 2<&3)
	
    exitstatus=$?
	exit 0

	# lang/ folder
    # for i in $options
    # do
		# creates & calls script path from selection 
		# i.e. "C++" --> langs/C++.sh
		# bash langs/"${i//\"}".sh "$configFile"
    # done
}

statuses=("DISABLED" "DISABLED" "DISABLED" "DISABLED")
languagesMenu

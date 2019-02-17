#!/bin/bash
source helpers.sh
configFile=$1

getStatuses() {
	if [[ $(valueOf "language.cpp.use" "$configFile") == "true" ]]; then 
		statuses[0]="ENABLED"
	else
		statuses[0]="DISABLED"
	fi

	if [[ $(valueOf "language.python.use" "$configFile") == "true" ]]; then 
		statuses[1]="ENABLED"
	else
		statuses[1]="DISABLED"
	fi

	if [[ $(valueOf "language.nodejs.use" "$configFile") == "true" ]]; then 
		statuses[2]="ENABLED"
	else
		statuses[2]="DISABLED"
	fi

	if [[ $(valueOf "language.java.use" "$configFile") == "true" ]]; then 
		statuses[3]="ENABLED"
	else
		statuses[3]="DISABLED"
	fi
}

fxn() {

	if [[ $(valueOf "language.python.use" "$configFile") == "true" ]]; then
		prefs[0]="ON"
	else 
		prefs[0]="OFF"
	fi
	
	if [[ $(valueOf "language.python.version.3" "$configFile") == "true" ]]; then
		prefs[1]="ON"
	else
		prefs[1]="OFF"
	fi

	if [[ $(valueOf "language.python.package.pandas" "$configFile") == "true" ]]; then
		prefs[2]="ON"
	else
		prefs[2]="OFF"
	fi

	if [[ $(valueOf "language.python.package.numpy" "$configFile") == "true" ]]; then
		prefs[3]="ON"
	else
		prefs[3]="OFF"
	fi	

	libs=$(whiptail --title "Python" --checklist \
"\nConfigure Python options:" \
--nocancel --ok-button "Done" 15 60 4 \
"Python" "(Uncheck to disable the language)" ${prefs[0]} \
"Python 3" "(Uncheck for Python 2)" ${prefs[1]} \
"Pandas" "Data structures & analysis" ${prefs[2]} \
"NumPy" "Computing with Python" ${prefs[3]} 3<&1 1<&2 2<&3)
	# TODO just echoes selections for now
	if [[ $libs == *"\"Python\""* ]]; then
		$(change "language.python.use" "true" "$configFile")
		
		if [[ $libs == *"\"Python 3\""* ]]; then
			$(change "language.python.version.3" "true" "$configFile")
			$(change "language.python.version.2" "false" "$configFile")
		else 
			$(change "language.python.version.3" "false" "$configFile")
			$(change "language.python.version.2" "true" "$configFile")
		fi

		if [[ $libs == *"\"Pandas\""* ]]; then
			$(change "language.python.package.pandas" "true" "$configFile")
		else
			$(change \
			"language.python.package.pandas" "false" "$configFile")
		fi

		if [[ $libs == *"\"NumPy\""* ]]; then
			$(change "language.python.package.numpy" "true" "$configFile")
		else
			$(change "language.python.package.numpy" "false" "$configFile")
		fi

	else
		$(change "language.python.use" "false" "$configFile")
		$(change "language.python.version.3" "false" "$configFile")
		$(change "language.python.version.2" "false" "$configFile")
		$(change "language.python.package.numpy" "false" "$configFile")
		$(change "language.python.package.pandas" "false" "$configFile")

	fi	
	languagesMenu
}

languagesMenu() {
	# obtains languages status (ENABLED/DISABLED)
	getStatuses

	# creates menu
    options=$(whiptail --title "Languages" --menu \
--ok-button "Back" \
--nocancel \
"\nConfigure languages" 15 60 4 \
"C++" "  ${statuses[0]}" \
"Python" "  ${statuses[1]}" \
"Javascript" "  ${statuses[2]}" \
"Java" "  ${statuses[3]}" 3<&1 1<&2 2<&3)
	
    exitstatus=$?

	if [ $exitstatus=0  ]; then
		case $options in
			"C++") bash C++.sh $configFile ;;
			"Python") fxn ;;
			"Javascript") bash Javascript.sh $configFile ;;
			"Java") bash Java.sh $configFile ;;
		esac

		bash main.sh $configFile
		exit 0
	fi
	exit 0
	# lang/ folder
    # for i in $options
    # do
		# creates & calls script path from selection 
		# i.e. "C++" --> langs/C++.sh
		# bash langs/"${i//\"}".sh "$configFile"
    # done
}


prefs=("OFF" "OFF" "OFF" "OFF")
statuses=("DISABLED" "DISABLED" "DISABLED" "DISABLED")
languagesMenu

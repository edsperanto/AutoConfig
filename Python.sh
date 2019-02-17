#!bin/bash
source helpers.sh

configFile=$1

# gets current preferences from config file
loadPreferences() {
	if [ $(valueOf "language.python.use" "$configFile") ]; then
		prefs[0]="ON"
	fi
	
	if [ $(valueOf "language.python.version.3" "$configFile") ]; then
		prefs[1]="ON"
	fi

	if [ $(valueOf "language.python.package.pandas" "$configFile") ]; then
		prefs[2]="ON"
	fi

	if [ $(valueOf "language.python.package.numpy" "$configFile") ]; then
		prefs[3]="ON"
	fi
}


# library selection whiptail checklist
configureOptions() {
	loadPreferences

	libs=$(whiptail --title "Python" --checklist \
"Configure Python options:" \
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

}

prefs=("OFF" "OFF" "OFF" "OFF")
configureOptions


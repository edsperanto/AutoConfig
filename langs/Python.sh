#!bin/bash
source helpers.sh

configFile=$1

# yesno whiptail to select python version
selectVersion() {
    if (whiptail --title "Python" --yesno \
--yes-button "Python 2" --no-button "Python 3" \
"Choose your desired Python version:" 10 60) then
		# TODO just echoes choice for now
        change "language.python.version.3" "false" "$configFile"
        change "language.python.version.2" "true" "$configFile"
	else
        change "language.python.version.3" "true" "$configFile"
        change "language.python.version.2" "false" "$configFile"
	fi
}


# library selection whiptail checklist
selectLibraries() {
	libs=$(whiptail --title "Python" --checklist \
"Select libraries to install:" 15 60 2 \
"Requests" "HTTP for Humans" OFF \
"NumPy" "Computing with Python" OFF 3<&1 1<&2 2<&3)
	# TODO just echoes selections for now
	echo $libs
}

selectVersion
selectLibraries


#!bin/bash

selectVersion() {
    if (whiptail --title "Python" --yesno \
--yes-button "Python 2" --no-button "Python 3" \
"Choose your desired Python version:" 10 60) then
		echo "Python 2"
	else
		echo "Python 3"
	fi
}

selectVersion


#!/bin/bash

userName="Not Set"
passWord="Not Set"
pubKey="Not Set"
homeDir="Not Set"
shellChoice="Not Set"

userMenu() {
	un="$(getUserName)"
	p="$(getPassWord)"
	pk="$(getPubKey)"
	hd="$(getHomeDir)"
	s="$(getShell)"
	
	userOption=$(whiptail --title "USER INFORMATION MENU" --menu "Choose which item you would like to change:" 15 60 5 \
	"Username:" "$un" \
	"Password:" "$p" \
	"Public Key:"  "$pk" \
	"Home Directory:" "$hd" \
	"Shell:" "$s" 3>&1 1>&2 2>&3)
	
	echo "$userOption"

	exitstatus=$?
	if [ $exitstatus = 0 ]; then

		echo "if state"

		if [ $userOption = "Username:" ]; then
			setUserName
		elif [ $userOption = "Password:" ]; then
			setPassword
		elif [ $userOption = "Public Key:" ]; then
			setPubKey
		elif [ $userOption = "Home Directory:" ]; then
			setHomeDir
		else
			setShell
		fi
	else
		echo "else state"
	fi

}

setUserName() {
	userName=$(whiptail --title "USER INFORMATION" --inputbox "Enter your username: " 15 60 3>&1 1>&2 2>&3)
	userMenu
}

setPassWord() {
	passWord=$(whiptail --title "USER INFORMATION" --inputbox "Enter your password: " 15 60 3>&1 1>&2 2>&3)
	userMenu
}

setPubKey() {
	pubKey=$(whiptail --title "USER INFORMATION" --input "Enter your public key: " 15 60 3>&1 1>&2 2>&3)
	userMenu
}

setHomeDir() {
	homeDir=$(whiptail --title "USER INFORMATION" --yesno "Would you like a home directory for this user?" 15 60) 
	userMenu
}

setShell() {
	shellChoice=$(whiptail --title "USER INFORMATION" --menu "Pick your preferred shell: "  15 60 3 \ 
	"1" "sh" \
	"2" "zsh" \
	"3" "bash" 3>&1 1>&2 2>&3)
	userMenu
}

getUserName() {
	echo "$userName"
}

getPassWord() {
	if [[ $passWord = "Not Set" ]]; then
		echo "Not Set"
	else
		echo "Hidden"
	fi
}

getPubKey() {
	echo "$pubKey"
}

getHomeDir() {
	echo "$homeDir"
}

getShell() {
	echo "$shellChoice"
}

userMenu

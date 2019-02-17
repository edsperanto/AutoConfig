#!/bin/bash
# users menu

source helpers.sh
configFile=$1

userTitle="USER CONFIGURATION"

userMenu() {
    local prompt="\nChoose which item you would like to change:"
    local userOption=$(whiptail --title "$userTitle" --menu "$prompt" 17 60 7 \
        "Username:" "$(valueOf "user.name" "$configFile")" \
        "Password:" "[hidden]" \
        "SSH Public Key:" "$(valueOf "user.ssh.pubkey.enabled" "$configFile")" \
        "Home Directory:" "$(valueOf "user.name" "$configFile")" \
        "Sudoer:" "$(valueOf "user.name" "$configFile")" \
        "Default Shell:" "$(valueOf "user.shell" "$configFile")" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
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
        exit 0
    fi
    exit 0

}

setUserName() {
    local userName=$(whiptail --title "$userTitle" --inputbox \
        "Enter your username: " 15 60 3>&1 1>&2 2>&3)
    change "user.name" "$userName" "$configFile"
    userMenu
}

setPassWord() {
    userPassword=$(whiptail --title "$userTitle" --inputbox \
        "Enter your password: " 15 60 3>&1 1>&2 2>&3)
    userMenu
}

setPubKey() {
    local pubKey=$(whiptail --title "$userTitle" --input \
        "Enter your public key: " 15 60 3>&1 1>&2 2>&3)
    change "user.ssh.pubkey" "$pubKey" "$configFile"
    userMenu
}

setHomeDir() {
    local homeDir=$(whiptail --title "$userTitle" --yesno \
        "Would you like a home directory for this user?" 15 60) 
    change "user.homedir" "$homeDir" "$configFile"
    userMenu
}

setShell() {
    local shellChoice=$(whiptail --title "$userTitle" --menu \
        "Pick your preferred shell: "  15 60 3 \ 
        "1" "sh" \
        "2" "bash" \
        "3" "zsh" 3>&1 1>&2 2>&3)
    change "user.shell" "$shellChoice" "$configFile"
    userMenu
}

userMenu

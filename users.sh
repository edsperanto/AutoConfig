#!/bin/bash
# users menu

source helpers.sh
configFile=$1

userTitle="USER CONFIGURATION"

userMenu() {
    local pk="$(getPubKey)"
    local hd="$(getHomeDir)"
    local su="$(getSudoer)"
    local prompt="\nChoose which item you would like to change:"
    local userOption=$(whiptail --title "$userTitle" --menu "$prompt" \
        --nocancel --ok-button "Done" 15 60 7 \
        "Username:" "$(valueOf "user.name" "$configFile")" \
        "Password:" "[hidden]" \
        "SSH Public Key:" "$pk"\
        "Home Directory:" "$hd" \
        "Sudoer:" "$su" \
        "Default Shell:" "$(valueOf "user.shell" "$configFile")" \
        "Go Back" " " 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if [[ $userOption = "Username:" ]]; then
            setUserName
        elif [[ $userOption = "Password:" ]]; then
            setPassword
        elif [[ $userOption = "SSH Public Key:" ]]; then
            setPubKey
        elif [[ $userOption = "Home Directory:" ]]; then
            setHomeDir
        elif [[ $userOption = "Sudoer:" ]]; then
            setSudoer
        elif [[ $userOption = "Default Shell:" ]]; then
            setDefShell
        else
            bash main.sh "$configFile"
        fi
    else
        exit 0
    fi
    exit 0

}

getPubKey() {
    local pubKey=$(valueOf "user.ssh.pubkey" "$configFile")
}

getHomeDir() {
    local homeDir=$(valueOf "user.homedir" "$configFile")
}

getSudoer() {
    local sudoer=$(valueOf "user.sudoer" "$configFile")
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

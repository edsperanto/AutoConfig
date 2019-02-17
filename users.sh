#!/bin/bash
# users menu

source helpers.sh
configFile=$1

userTitle="USER CONFIGURATION"

userMenu() {
    local hd="$(getHomeDir)"
    local su="$(getSudoer)"
    local userSh="$(valueOf "user.shell" "$configFile")"
    local prompt="\nChoose which item you would like to change:"
    local userOption=$(whiptail --title "$userTitle" --menu "$prompt" \
        --nocancel --ok-button "Done" 15 60 7 \
        "1" "Username: $(valueOf "user.name" "$configFile")" \
        "2" "Password: [hidden]" \
        "3" "SSH Public Key: [hidden]"\
        "4" "Home Directory: $hd" \
        "5" "Sudoer: $su" \
        "6" "Default Shell: $userSh" \
        "7" "Go Back" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $userOption in
            1) setUserName ;;
            2) setPassword ;;
            3) setPubKey ;;
            4) setHomeDir ;;
            5) setSudoer ;;
            6) setDefShell ;;
            7) bash main.sh "$configFile" ;;
        esac
    fi

}

getHomeDir() {
    local homeDir=$(valueOf "user.homedir" "$configFile")
    if [[ $homeDir == "true" ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

getSudoer() {
    local sudoer=$(valueOf "user.sudoer" "$configFile")
    if [[ $sudoer == "true" ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

setUserName() {
    local userName=$(whiptail --title "$userTitle" --inputbox \
        "Enter your username: " 15 60 3>&1 1>&2 2>&3)
    change "user.name" "$userName" "$configFile"
    userMenu
}

setPassword() {
    local userPassword=$(whiptail --title "$userTitle" --passwordbox \
        "Enter your password: " 15 60 3>&1 1>&2 2>&3)
    change "user.password" "$userPassword" "$configFile"
    userMenu
}

setPubKey() {
    local pubKey=$(whiptail --title "$userTitle" --inputbox \
        "Enter your public key file: " 15 60 3>&1 1>&2 2>&3)
    change "user.ssh.pubkey" "$pubKey" "$configFile"
    userMenu
}

setHomeDir() {
    local prompt="Would you like a home directory for this user?"
    if(whiptail --title "$userTitle" --yesno "$prompt" 15 60) then
        change "user.homedir" "true" "$configFile"
    else
        change "user.homedir" "false" "$configFile"
    fi
    userMenu
}

setSudoer() {
    local prompt="Would you like this user to be a sudoer?"
    if(whiptail --title "$userTitle" --yesno "$prompt" 15 60) then
        change "user.sudoer" "true" "$configFile"
    else
        change "user.sudoer" "false" "$configFile"
    fi
    userMenu
}

setDefShell() {
    local shellChoice=$(whiptail --title "$userTitle" --menu \
        "Pick your preferred shell: " --nocancel --ok-button "Done" 15 60 3 \ 
        "1" "sh" \
        "2" "bash" \
        "3" "zsh" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $shellChoice in
            1) change "user.shell" "sh" "$configFile" ;;
            2) change "user.shell" "bash" "$configFile" ;;
            3) change "user.shell" "zsh" "$configFile" ;;
        esac
    fi
    userMenu
}

userMenu

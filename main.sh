#!/bin/bash
# main menu

if [ $# -eq 0 ]; then
    configFile="null"
else
    configFile=$1
fi

welcome() {
    local prompt="\nDo you have a saved config file?"
    if (whiptail --title "Welcome!" --yesno "${prompt}" 10 50) then
        getConfig
    else
        mainMenu
    fi
}

getConfig() {
    local prompt="\nWhat is the name of your config file?"
    configFile=$(whiptail --title "Config File" --inputbox "${prompt}" \
        10 50 my_config 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        mainMenu $initFile
    else
        welcome
    fi
}

mainMenu() {
    if [[ $configFile != "null" ]]; then
        local prompt="\nLoaded configurations from ${configFile}."
    else
        cp default_config my_config;
        configFile="my_config"
        local prompt="\nLoaded default configurations. What do you want to do?"
    fi
    local option=$(whiptail --title "Main Menu" --menu "${prompt}" \
        --cancel-button "Quit" 15 60 6 \
        "1" "Configure users" \
        "2" "Configure languages" \
        "3" "Configure shells" \
        "4" "Configure editors" \
        "5" "Configure miscellaneous" \
        "6" "Apply configurations" 3>&1 1>&2 2>&3)
    exitstatus=$?
    echo "exitstatus: ${exitstatus}"
    if [ $exitstatus = 0 ]; then
        case $option in
            1) bash users.sh $configFile ;;
            2) bash languages.sh $configFile ;;
            3) bash shells.sh $configFile ;;
            4) bash editors.sh $configFile ;;
            5) bash miscellaneous.sh $configFile ;;
            6) bash apply.sh $configFile ;;
        esac
    else
        exit 0
    fi
}

if [ $# -eq 0 ]; then
    welcome
else
    mainMenu
fi

#!/bin/bash
# main menu

if [ $# -eq 0 ]; then
    exit 0
else
    configFile=$1
fi

findEditorDir() {
    local editor=$(sudo update-alternatives --display editor | grep '^\/.*' | \
        cut -f1 -d" " | grep -E -o "[^[:space:]]*/$1")
}

getEditorsList() {
    echo $(sudo update-alternatives --display editor | grep '^\/.*' | \
        cut -f1 -d" ")
}

loadEditorsConfig() {
    declare -A editorsConfig
    editors
}

editorsMenu() {
    local title="Editors Configuration"
    local prompt="\nPick your default editor"
    local option=$(whiptail --title "${title}" --menu "${prompt}" 15 60 6 \
        "1" "ed" \
        "2" "nano" \
        "3" "vim" \
        "4" "emacs" \
        "5" "Return to Main Menu" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $option in
            1) echo "You selected one";;
            2) echo "You selected two";;
            3) bash main.sh $configFile ;;
        esac
    else
        welcome
    fi
}

getEditorsList

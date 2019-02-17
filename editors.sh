#!/bin/bash
# editors menu

configFile=$1

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
            1) change "editor.default" "ed" "$configFile";;
            2) change "editor.default" "nano" "$configFile";;
            3) change "editor.default" "vim.basic" "$configFile";;
            4) change "editor.default" "emacs" "$configFile";;
            5) bash main.sh $configFile ;;
        esac
    else
        exit 0
    fi
}

getEditorsList

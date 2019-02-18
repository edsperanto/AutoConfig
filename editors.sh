#!/bin/bash
# editors menu

source helpers.sh
configFile=$1

title="EDITORS CONFIGURATION"

findEditorDir() {
    local editor=$(sudo update-alternatives --display editor | grep '^\/.*' | \
        cut -f1 -d" " | grep -E -o "[^[:space:]]*/$1")
}

getEditorsList() {
    echo $(sudo update-alternatives --display editor | grep '^\/.*' | \
        cut -f1 -d" ")
}

editorsMenu() {
    local defEditor=$(valueOf "editor.default" "$configFile")
    local prompt="\nYour current default editor is $defEditor"
    local option=$(whiptail --title "${title}" --menu "${prompt}" \
        --nocancel --ok-button "Done" 15 60 6 \
        "1" "ed" \
        "2" "nano" \
        "3" "vim" \
        "4" "emacs" \
        "5" "Return to Main Menu" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $option in
            1) useEd ;;
            2) useNano ;;
            3) useVim ;;
            4) useEmacs ;;
            5) bash main.sh $configFile
        esac
    fi
}

useEd() {
    local prompt="Set ed as your default editor?"
    if (whiptail --title "$title" --yesno "$prompt" 15 60) then
        change "editor.default" "ed" "$configFile"
    else
        editorsMenu
    fi
    editorsMenu
}

useNano() {
    local prompt="Set nano as your default editor?"
    if (whiptail --title "$title" --yesno "$prompt" 15 60) then
        change "editor.default" "nano" "$configFile"
    else
        editorsMenu
    fi
    editorsMenu
}

useVim() {
    local prompt="Set vim as your default editor?"
    if (whiptail --title "$title" --yesno "$prompt" 15 60) then
        change "editor.default" "vim.basic" "$configFile"
    else
        editorsMenu
    fi
    editorsMenu
}

getVimStatus() {
    local vimPkg="editor.vim.package"
    if [[ $(valueOf "$vimPkg.emmet" "$configFile") == "true" ]]; then
        vimPkgsStats[0]="ENABLED"
    else
        vimPkgsStats[0]="DISABLED"
    fi
    if [[ $(valueOf "$vimPkg.nerdtree" "$configFile") == "true" ]]; then
        vimPkgsStats[1]="ENABLED"
    else
        vimPkgsStats[1]="DISABLED"
    fi
    if [[ $(valueOf "$vimPkg.autopairs" "$configFile") == "true" ]]; then
        vimPkgsStats[2]="ENABLED"
    else
        vimPkgsStats[2]="DISABLED"
    fi
}

vimSettings() {
    local vimPkg="editor.vim.package"
    local options=$(whiptail --title "$title" --menu --ok-button "Back" \
        --nocancel "\nSelect vim packages to install" 15 60 4 \
        "Emmet" "Auto-complete for HTML & CSS" ${vimPkgsStats[0]} \
        "NerdTree" "File explorer plugin" ${vimPkgsStats[1]} \
        "Auto-Pairs" "Auto-pairing for quotes and brackets" ${vimPkgsStats[2]} \
        3<&1 1<&2 2&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $option in
            "Emmet") change "$vimPkg.emmet" 
        esac
    fi
    editorsMenu
}

useEmacs() {
    local prompt="Set emacs as your default editor?"
    if (whiptail --title "$title" --yesno "$prompt" 15 60) then
        change "editor.default" "emacs" "$configFile"
    else
        editorsMenu
    fi
    editorsMenu
}

vimPkgsStats=("DISABLED" "DISABLED")
editorsMenu

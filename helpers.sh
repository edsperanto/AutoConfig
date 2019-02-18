#!/bin/bash

BLACK_FG=`tput setaf 0`
RED_FG=`tput setaf 1`
GREEN_FG=`tput setaf 2`
YELLOW_FG=`tput setaf 3`
BLUE_FG=`tput setaf 4`
MAGENTA_FG=`tput setaf 5`
CYAN_FG=`tput setaf 6`
WHITE_FG=`tput setaf 7`
BLACK_BG=`tput setab 0`
WHITE_BG=`tput setab 7`
RESET=`tput sgr0`
BOLD=`tput bold`
UNDERLINE=`tput smul`
NO_UNDERLINE=`tput rmul`

# USAGE: valueOf "key" "config_file"
valueOf() {
    echo $(grep $1 $2 | sed 's/.*=\(.*\)/\1/')
}

#USAGE: change "key" "value" "config_file"
change() {
    local key=$1
    local value=$2
    local configFile=$3
    sed -i "s/${key}=.*/${key}=${value}/" "${configFile}"
}

bold() {
    printf "${BOLD}$*${RESET}\n"
}

warn() {
    printf "${RED_FG}$*${RESET}\n"
}

fin() {
    printf "${GREEN_FG}$*${RESET}\n"
}

runCmd() {
    echo $password | sudo -S -u $userName -H bash -c "$1"
}

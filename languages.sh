configFile=$1

mainMenu() {
    local options=$(whiptail --title "Languages" --checklist "Select languages you would like to configure" 15 60 4 \ "C++" "" OFF \ "Python" "" OFF \ "Javascript" "" OFF \ "Java" "" OFF 3<&1 1<&2 2<&3)
    
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "Chose: $options"
    else
        echo $exitstatus
    fi	
}

mainMenu

#!/bin/bash
# apply all configurations

source helpers.sh
configFile=$1

sudoOrNo() {
    sudoer=$(valueOf "user.sudoer" "$configFile")
    if [[ $sudoer == "true" ]]; then
        echo "sudoer"
    else
        echo "non sudoer"
    fi
}

homeDirOrNo() {
    homeDir=$(valueOf "user.homedir" "$configFile")
    if [[ $sudoer == "true" ]]; then
        echo "with home directory"
    else
        echo "without home directory"
    fi
}

printf "\n"
bold "===== INSTALLING THE BASICS ====="
printf "Installing curl... "
sudo apt-get install curl -y &>/dev/null
fin "SUCCESS"
printf "Installing tar... "
sudo apt-get install tar -y &>/dev/null
fin "SUCCESS"
printf "Installing gzip... "
sudo apt-get install gzip -y &>/dev/null
fin "SUCCESS"

printf "\n"
userName=$(valueOf "user.name" "$configFile")
password=$(valueOf "user.password" "$configFile")
defShell=$(valueOf "user.shell" "$configFile")
bold "===== CREATING USER ====="
printf "Creating new $(sudoOrNo) $userName $(homeDirOrNo)... "
if [[ $homeDir == "true" ]]; then
    sudo adduser --disabled-password --gecos "" -m "$userName" &>/dev/null
else
    sudo adduser --disabled-password --gecos "" "$userName" &>/dev/null
fi
fin "SUCCESS"
if [[ $sudoer == "true" ]]; then
    sudo usermod -aG sudo "$userName" &>/dev/null
fi
printf "Changing default shell of $userName to $defShell... "
sudo usermod -s $(which $defShell) $userName &>/dev/null
fin "SUCCESS"
printf "Setting password for $userName... "
echo "$userName:$password"| sudo chpasswd &>/dev/null
fin "SUCCESS"

printf "\n"
bold "===== SETTING UP LANGUAGES ====="
useCPP=$(valueOf "language.cpp.use" "$configFile")

if [[ $useCPP == "true" ]]; then
	echo "installing cpp"
else
	echo "No C++ tools selected."
fi

usePy=$(valueOf "language.python.use" "$configFile")

if [[ $usePy == "true" ]]; then
	echo "installing python!"
else
	echo "No Python tools selected."
fi

useNode=$(valueOf "language.nodejs.use" "$configFile")

if [[ $useNode == "true" ]]; then
	echo "installing node"
else
	echo "No Node.js tools selected."
fi

useJava=$(valueOf "language.java.use" "$configFile")

if [[ $useJava == "true" ]]; then
	echo "installing java"
else
	echo "No Java tools selected."
fi

printf "\n"
bold "===== SETTING UP EDITOR ====="


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
	# TODO not real
	printf "installing cpp... "
	fin "SUCCESS"
else
	printf "No C++ tools selected.\n"
fi


pyLibs() {
	pip=$0
	numpy=$(valueOf "language.python.package.numpy" "$configFile")
	pandas=$(valueOf "language.python.package.pandas" "$configFile")

	if [[ $numpy == "true" ]]; then
		printf "NumPy "
		runCmd "echo $password | sudo -S $pip install numpy -y"
	fi
	if [[ $pandas == "true" ]]; then
		printf "Pandas "
		runCmd "echo $password | sudo -S $pip install pandas -y"
	fi

	fin "SUCCESS"
	
}

usePy=$(valueOf "language.python.use" "$configFile")

if [[ $usePy == "true" ]]; then
	printf "Installing Python tools... "

	py3=$(valueOf "language.python.version.3" "$configFile")
	if [[ $py3 == "true" ]]; then 
		runCmd "echo $password | sudo -S apt-get install python3 -y"
		runCmd "echo $password | sudo -S apt-get install python3-pip -y"
		printf "Python3 "
		pyLibs "pip3"
	else
		runCmd "echo $password | sudo -S apt-get install python -y"
		runCmd "echo $password | sudo -S apt-get install python-pip -y"
		printf "Python2 "
		pyLibs "pip"
	fi

else
	printf "No Python tools selected.\n"
fi

useNode=$(valueOf "language.nodejs.use" "$configFile")

if [[ $useNode == "true" ]]; then
	# TODO not real
	printf "installing node... "
	fin "SUCCESS"
else
	printf "No Node.js tools selected.\n"
fi

useJava=$(valueOf "language.java.use" "$configFile")

if [[ $useJava == "true" ]]; then
	# TODO not real
	printf "installing java... "
	fin "SUCCESS"
else
	printf "No Java tools selected.\n"
fi

printf "\n"
bold "===== CONFIGURING EDITOR ====="
printf "Installing vim... "
runCmd "echo $password | sudo -S apt-get install vim -y"
fin "SUCCESS"
printf "Installing pathogen for vim... "
runCmd "mkdir ~/.vim ~/.vim/tmp; mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
fin "SUCCESS"
printf "Installing emmet for vim... "
runCmd "cd ~/.vim/bundle; git clone https://github.com/mattn/emmet-vim.git"
fin "SUCCESS"
printf "Installing nerdtree for vim... "
runCmd "cd ~/.vim/bundle; git clone https://github.com/scrooloose/nerdtree.git"
fin "SUCCESS"
printf "Installing auto-pairs for vim... "
runCmd "cd ~/.vim/bundle; git clone https://github.com/jiangmiao/auto-pairs.git"
fin "SUCCESS"

printf "\n"
bold "===== CONFIGURING MISCELLANEOUS ====="
printf "Installing tmux... "
runCmd "echo $password | sudo -S apt-get install tmux -y"
fin "SUCCESS"
printf "Installing tpm for tmux... "
runCmd "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fin "SUCCESS"
printf "Copying dotfiles... "
cp tmux.conf ~/.tmux.conf
cp bashrc ~/.bashrc
cp vimrc ~/.vimrc
fin "SUCCESS"

bold "===== LOGGING IN AS YOUR NEW USER ====="
userName=$(valueOf "user.name" "$configFile")
su - $userName

#!/bin/bash

sudo apt-get install git -y
sudo apt-get install whiptail -y

cd ~
git clone https://github.com/edsperanto/AutoConfig.git
cd AutoConfig

sudo bash main.sh

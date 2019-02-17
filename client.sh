#!/bin/bash

sudo apt-get install wget -y
sudo apt-get install git -y
sudo apt-get install curl -y
sudo apt-get install tar -y
sudo apt-get install gzip -y
sudo apt-get install whiptail -y

cd ~
git clone https://github.com/edsperanto/AutoConfig.git
cd AutoConfig

bash main.sh

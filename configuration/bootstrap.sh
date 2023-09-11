#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install python3-pip -y
sudo apt install net-tools
sudo apt remove python3-pip 
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

mkdir /home/ubuntu/etc
mkdir /home/ubuntu/etc/scripts
mkdir /home/ubuntu/etc/scripts/result

pip install -r /home/ubuntu/etc/scripts/requirements.txt
PATH=/home/ubuntu/.local/bin:$PATH

sudo apt-get update -y && sudo apt install mysql-client -y

sudo apt update && sudo apt upgrade
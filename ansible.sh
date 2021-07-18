#!/bin/bash
# This file should be sourced

# Change directory to user home
cd /home/useradmin

# Upgrade all packages that have available updates and remove old ones.
sudo apt-get update
sudo apt upgrade -y
sudo apt autoremove --assume-yes

# Install git
sudo apt install git --assume-yes

# Install azcli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install venv and pip
sudo apt install python3-venv --assume-yes
sudo apt install python3-pip --assume-yes

# Setup virtual environment and push home folder ownership
sudo python3 -m venv venv
sudo chown adminuser /home/adminuser --recursive

# Install ansible and azure modules into virtual environment
pip3 install -r https://raw.githubusercontent.com/DFW1N/shell-scripts/main/ansible-requirements.txt
pip3 install -r https://raw.githubusercontent.com/DFW1N/shell-scripts/main/azure-requirements.txt

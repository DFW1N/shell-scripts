#! /bin/bash

sudo apt update -y
sudo apt install python-pip -y
sudo pip install ansible -y
sudo ansible-galaxy install azure.azure_preview_modules
sudo pip install -r ~/.ansible/roles/azure.azure_preview_modules/files/requirements-azure.txt

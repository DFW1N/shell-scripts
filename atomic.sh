#!/bin/bash

# Update the list of packages
sudo apt-get update -y
sudo apt upgrade -y
sudo apt autoremove --assume-yes

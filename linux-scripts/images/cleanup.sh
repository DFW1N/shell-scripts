#!/bin/bash -eux

#echo "Unistalling ansible..."
#sudo apt-get remove -qy ansible
#
#echo "Removing ansible-local"
#rm -rf /home/ubuntu/ansible-local
sudo rm -r /ansible-local

echo "Autoremoving apt..."
sudo apt-get -qy autoremove

#echo "Updating apt..."
sudo apt-get clean
sudo apt-get -qy update


#Disable the root account
sudo passwd -l root

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

#!/bin/bash

# Bootstrap a machine sufficiently to run Ansible:
#
#  - apt update, upgrade
#  - Install Ansible and git

## Wait for apt to be free.
i=0
tput sc
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    case $(($i % 4)) in
        0 ) j="-" ;;
        1 ) j="\\" ;;
        2 ) j="|" ;;
        3 ) j="/" ;;
    esac
    tput rc
    echo -en "\r[$j] Waiting for other software managers to finish..."
    sleep 0.5
    ((i=i+1))
done

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

#echo "Updating apt..."
sudo apt-get clean
sudo apt-get -qy update

## apt-get upgrade commentd out for epp compatibility.
#echo "Upgrading apt..."
#sudo apt-get -qy upgrade
## workaround for grub https://github.com/chef/bento/issues/661#issuecomment-248136601
# sudo DEBIAN_FRONTEND=noninteractive apt-get -qy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

#echo "Installing ansible..."
#sudo apt-get install -qy ansible

echo "Adding ansible repo/ppa"
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
echo "update apt-get and install ansible"
sudo apt-get update -y
sudo apt-get install -y ansible
sudo ln  -s /usr/bin/ansible-playbook /bin/ansible-playbook
sudo mkdir /ansible-local
sudo chmod 777 /ansible-local

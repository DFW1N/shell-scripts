  
#!/bin/bash
# Update the list of packages
sudo apt-get update -y;
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb;
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb;
# Update the list of packages after we added packages.microsoft.com
sudo apt-get update -y;
# Install PowerShell
sudo apt-get install -y powershell;
# Start PowerShell

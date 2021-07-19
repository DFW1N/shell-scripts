####################
## AUDITD INSTALL ##
####################

# AUTHOR: SACHA ROUSSAKIS-NOTTER

# Installing auditd
sudo apt install -y auditd

# Downloading and installing the MITRE attack rules
wget -q -P /etc/audit/rules.d mitre_attack.rules https://raw.githubusercontent.com/DFW1N/shell-scripts/main/mitre_attack.rules

# Restarting auditd service
service auditd restart

# Over writing systemd-user file with curl command
curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/systemd-user > /etc/pam.d/systemd-user

# Over writing sshd file with curl command
curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/sshd > /etc/pam.d/sshd

# Download Linux OMS Agent (Change /home/adminuser to your linux {Username})
wget -P ~/home/adminuser/ https://github.com/microsoft/OMS-Agent-for-Linux/releases/download/OMSAgent_v1.13.35-0/omsagent-1.13.35-0.universal.x64.sh
# Install OMS Agent (Change -w Workspace and -s Shared key) (Log Analytics Workspaces > Workspace > Agents management > Workspace ID {VALUE} > Primary Key {VALUE}
sudo sh ./omsagent-*.universal.x64.sh --upgrade -w {WORKSPACE ID} -s {LINUX PRIMARY KEY}
# Copy the omsagent .conf file to the omsagent workspace
sudo cp /etc/opt/microsoft/omsagent/sysconf/omsagent.d/auditlog.conf /etc/opt/microsoft/omsagent/60d75d70-760a-4c85-9fe8-2db198997a00/conf/omsagent.d/
# Restart the OMS Agent
sudo /opt/microsoft/omsagent/bin/service_control restart
# Check OMS Agent log for Agent Restart
sudo tail /var/opt/microsoft/omsagent/<workspace id>/log/omsagent.log

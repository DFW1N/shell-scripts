# Ubuntu 18.04 - Linux auditd

This Shell script has been designed to allow Azure Sentinel to congest the auditd logs so you can monitor your Linux virtual machines from your Azure environment without having to get other data connectors connected from the Sentinel environment.

## [↑](#contents) Credits
Contributor:                                                [<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/DFW1N%20Logo.png" align="right" width="120">](https://github.com/DFW1N/DFW1N-OSINT)

- [Sacha Roussakis-Notter](https://github.com/DFW1N)

 [![Follow Sacha Roussakis | Sacha on Twitter](https://img.shields.io/twitter/follow/Sacha.svg?style=social&label=Follow%20%40Sacha)](https://twitter.com/intent/user?screen_name=sacha_roussakis "Follow Sacha Roussakis | Sacha on Twitter")

## [↑](#contents) Files used in Shell Script:
- [mitre_attack.rules](https://github.com/DFW1N/shell-scripts/blob/main/mitre_attack.rules)
- [sshd](https://github.com/DFW1N/shell-scripts/blob/main/auditd/sshd) - Replaces auditd sshd file with required changes
- [systemd-user](https://github.com/DFW1N/shell-scripts/blob/main/auditd/systemd-user) - Replaces auditd systemd-user file with required changes
- [auditd_setup.sh](https://github.com/DFW1N/shell-scripts/blob/main/auditd/auditd_setup.sh)

## [↑](#contents) Prerequisites:

### Please do not forget to give this script the correct permissions with the following command:

    chmod +x auditd_setup.sh

### Also change the Variables inside the Shell Script to meet your own environment:

    workplaceID="00000000-0000-0000-0000-000000000000"
    primaryKey="0000000000000000000000000000000000000"
    linuxuser="adminuser"

Please look at the bottom if you need a guide to finding you're Azure Log Analytics Workspace Values.

## [↑](#contents) Shell Script Code:

    #! /bin/bash

    #######################################
    ## WRITTEN BY: SACHA ROUSSAKIS-NOTTER #
    #######################################

    ##############
    ## VARIABLES #
    ##############

    # Both values can be found in " Log Analytics Workspace > Workspace Name > Agents Management > Linux Servers > Workspace ID & Primary Key "
    workplaceID="00000000-0000-0000-0000-000000000000" # <------ Change to your Workspace ID
    primaryKey="0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" # <------ Change to your Workspace Primary Key
    linuxuser="adminuser"  # <------ Change to your Linux VM administrator user

    # Updating Azure Virtual Ubuntu Machine
    sudo apt-get update -y
    sudo apt upgrade -y
    sudo apt autoremove --assume-yes

    ####################
    ## AUDITD INSTALL ##
    ####################

    # Installing auditd
    sudo apt install -y auditd

    # Downloading and installing the MITRE attack rules
    wget -q -P /etc/audit/rules.d mitre_attack.rules https://raw.githubusercontent.com/DFW1N/shell-scripts/main/mitre_attack.rules

    # Restarting auditd service
    sudo service auditd restart

    # Over writing systemd-user file with curl command
    sudo curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/systemd-user > /etc/pam.d/systemd-user

    # Over writing sshd file with curl command
    sudo curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/sshd > /etc/pam.d/sshd

    # Download Linux OMS Agent
    sudo wget -q -P /home/$linxuser/ https://github.com/microsoft/OMS-Agent-for-Linux/releases/download/OMSAgent_v1.13.35-0/omsagent-1.13.35-0.universal.x64.sh
    sleep 2
    # Giving the downloaded shell script full permissions
    sudo chmod +x omsagent-1.13.35-0.universal.x64.sh
    
    # Install OMS Agent
    sudo sh ./omsagent-*.universal.x64.sh --upgrade -w $workplaceID -s $primaryKey
    # Copy the omsagent .conf file to the omsagent workspace
    sudo cp /etc/opt/microsoft/omsagent/sysconf/omsagent.d/auditlog.conf /etc/opt/microsoft/omsagent/$workplaceID/conf/omsagent.d/
    # Restart the OMS Agent
    sudo /opt/microsoft/omsagent/bin/service_control restart
    # Giving the logs 8 seconds to generate before checking OMS Agent Log
    sleep 8
    # Check OMS Agent log for Agent Restart
    sudo tail /var/opt/microsoft/omsagent/$workplaceID/log/omsagent.log

## [↑](#contents) KQL Ingestion Operator:

Once this has been deployed to your Linux virtual machine you can use the LinuxAuditLog_CL query. You can see an example below:

Confirm Linux Heartbeat:

    Heartbeat
    | where OSType == 'Linux'
    | summarize arg_max(TimeGenerated, *) by SourceComputerId
    | sort by Computer
    | render table

KQL Query with auditd:

     LinuxAuditLog_CL
    | order by TimeGenerated
    | extend ConsoleCommand = strcat(a0_s," ",a1_s," ",a2_s," ",a3_s)
    | where RecordType_s == "EXECVE"
    | where ConsoleCommand contains "ssh localhost" or ConsoleCommand contains "ssh -o"
         or ConsoleCommand contains "nano -s /bin/sh"
    | project TimeGenerated, ConsoleCommand, RecordType_s, Computer, AuditID_s
    
 ## [↑](#contents) Log Analytics Workspace Guide:
 
 1. Log into your azure portal at https://portal.azure.com
 2. Search for:
 
 ![image](https://user-images.githubusercontent.com/45083490/126265430-394f5116-ea5c-49ca-a62c-831c0d8d1242.png)
 
 3. Select it then select your workspace
 
 ![image](https://user-images.githubusercontent.com/45083490/126265485-e0c8b606-0dc5-48e8-b906-38a065a99280.png)
 
 4. Complete Steps shown in picture:
 
 ![image](https://user-images.githubusercontent.com/45083490/126265929-aa665320-da8b-4dfb-9106-8e4f604ea3b9.png)



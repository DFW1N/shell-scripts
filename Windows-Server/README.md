## Windows Server Installation PowerShell

Install Windows Active Directory Domain Services using PowerShell instead of the GUI.

        
1. Use the following install command to automatically install Active Directory Domain Services:

        Install-WindowsFeature –Name AD-Domain-Services –IncludeManagementTools

Importing the Required Modules
Now – the installation is technically complete, however, this article is not going to end there. We are now going to install some additional modules to make the server run smoother, and also walk you through the process of setting up a new forest to make your active directory work.

2. Deploy custom ADDSForest with:

       Install-ADDSForest `

         -DomainName "example.com" `

         -CreateDnsDelegation:$false ` 

         -DatabasePath "C:\Windows\NTDS" ` 

         -DomainMode "7" ` 

         -DomainNetbiosName "example" ` 

         -ForestMode "7" ` 

         -InstallDns:$true ` 

         -LogPath "C:\Windows\NTDS" ` 

         -NoRebootOnCompletion:$True ` 

         -SysvolPath "C:\Windows\SYSVOL" ` 

         -Force:$true

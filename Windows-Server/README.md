## Windows Server Installation PowerShell

Install Windows Active Directory Domain Services using PowerShell instead of the GUI.

1. Get Windows Features using the command:
 
        get-windowsfeature
        
2. Use the following install command to automatically install Active Directory Domain Services:

        install-windowsfeature AD-Domain-Services

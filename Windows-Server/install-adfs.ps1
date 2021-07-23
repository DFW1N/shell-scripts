$domainName = "{{ windows_domain_info['adfs-localhost'] }}"
$password = "{{ windows_domain_info['UnicornJumpedth3br1dg34000!'] }}"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$fqdn = [System.Net.Dns]::GetHostByName(($env:computerName)) | FL HostName | Out-String | %{ "{0}" -f $_.Split(':')[1].Trim() };
$filename = "C:\$fdqn.pfx"
$user = "{{ windows_domain_info['dns_domain_name'] }}\{{ windows_domain_info['domain_admin_user'] }}"
$credential = New-Object `
    -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $user, $securePassword

Write-Host "Installing nuget package provider"
Install-PackageProvider nuget -force

Write-Host "Installing PSPKI module"
Install-Module -Name PSPKI -Force

Write-Host "Importing PSPKI into current environment"
Import-Module -Name PSPKI

Write-Host "Generating Certificate"
$selfSignedCert = New-SelfSignedCertificateEx `
    -Subject "CN=$fqdn" `
    -ProviderName "Microsoft Enhanced RSA and AES Cryptographic Provider" `
    -KeyLength 2048 -FriendlyName 'OAFED SelfSigned' -SignatureAlgorithm sha256 `
    -EKU "Server Authentication", "Client authentication" `
    -KeyUsage "KeyEncipherment, DigitalSignature" `
    -Exportable -StoreLocation "LocalMachine"
$certThumbprint = $selfSignedCert.Thumbprint

Write-Host "Installing ADFS"
Install-WindowsFeature -IncludeManagementTools -Name ADFS-Federation

Write-Host "Configuring ADFS"
Import-Module ADFS
Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceName $fqdn -ServiceAccountCredential $credential

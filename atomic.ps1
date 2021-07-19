#! /usr/bin/pwsh

IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1')
Install-AtomicRedTeam -getAtomics -InstallPath "~\AtomicRedTeam" -Force
Invoke-AtomicTest

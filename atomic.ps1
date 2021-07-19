#! /usr/bin/pwsh

IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -InstallPath "~\AtomicRedTeam" -Force
Invoke-AtomicTest

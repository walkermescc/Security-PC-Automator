# Security-PC-Automator
 
This tool has been created to Automate a couple of tasks, that would have usually been manual. It will download tools depending on your choice. Please see the list below:

| Application Name | Parameter |
|------------------|-----------|
| Wireshark        |           |
| NMap             |           |
| Advance IP Scanner|            |
| Burp Suite Free Edition |            |
| Python           |           |
| Nano             |           |
| Filezilla        |           |
| GNS3             |           |
| Sysinternals     |           |
| WinSCP                 |           |
| Putty                 |           |
| WinMerge                 |           |
| VSCode                 |           |
| Virtualbox                 |           |
| VMWare Workstation                 |           |
| Notepad ++                 |           |
| VLC                 |           |
| Google Chrome                 |           |
| 7-Zip                 |           |
| Adobe Reader                 |           |


"All" = @("Standard","Minimal","Pentest","Developer")
    "Pentest" = @("Standard","Wireshark","nmap", "advanced-ip-scanner","burp-suite-free-edition")
    "Developer" = @("python3", "nano", "filezilla", "gns3", "sysinternals", "winscp", "putty","winmerge","vscode")
    "Standard" = @("Minimal","virtualbox","vmwareworkstation","notepad++","vlc" )
    "Minimal" = @("googlechrome", "7zip","adobereader" )

# Security-PC-Automator
 
This tool has been created to Automate a couple of tasks, that would have usually been manual. It will download tools depending on your choice. Please see the list below:

| Application Name | All       | Standard| Minimal | Pentest| Developer|
|------------------|-----------|----------|--------|----------|--------|
| Wireshark        |     y      |         |        |    y      |        |
| NMap             |     y      |         |        |    y      |        |
| Advance IP Scanner|    y      |         |        |    y      |        |
| Burp Suite Free Edition |  y  |         |        |    y      |        |
| Python           |     y      |         |        |          |    y    |
| Nano             |     y      |         |        |          |    y    |
| Filezilla        |     y      |         |        |          |    y    |
| GNS3             |     y      |         |        |          |    y    |
| Sysinternals     |     y      |         |        |          |    y    |
| WinSCP           |     y      |         |        |          |    y    |
| Putty            |     y      |         |        |          |    y    |
| WinMerge         |     y      |         |        |          |    y    |
| VSCode           |     y      |         |        |          |    y    |
| Virtualbox       |     y      |         |    y    |     y     |        |
| VMWare Workstation|    y       |        |    y    |     y     |        |
| Notepad ++       |     y      |         |    y    |     y     |        |
| VLC              |     y      |         |    y    |     y     |        |
| Google Chrome    |     y      |    y     |   y     |    y      |       |
| 7-Zip            |     y      |    y     |   y    |     y     |       |
| Adobe Reader     |     y      |    y     |   y     |    y      |       |


"All" = @("Standard","Minimal","Pentest","Developer")
    "Pentest" = @("Standard","Wireshark","nmap", "advanced-ip-scanner","burp-suite-free-edition")
    "Developer" = @("python3", "nano", "filezilla", "gns3", "sysinternals", "winscp", "putty","winmerge","vscode")
    "Standard" = @("Minimal","virtualbox","vmwareworkstation","notepad++","vlc" )
    "Minimal" = @("googlechrome", "7zip","adobereader" )

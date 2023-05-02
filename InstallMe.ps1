# ------------------------------------------------- Information -------------------------------------------------
# Title - Security PC Automator
# Author - Vincent Walker
# Date - 28/04/2023

# ------------------------------------------------- Parameters -------------------------------------------------

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("All","Standard","Minimal","Pentest","Developer")]
    [string]$PackageSet,
    [Parameter(Mandatory=$false)]
    [ValidateSet("Setup")]
    [string]$VM,
    [Parameter(Mandatory=$false)]
    [switch]$Uninstall
)

# ------------------------------------------------- PackagesSets -------------------------------------------------
$PackageSets = @{
    "All" = @("Standard","Minimal","Pentest","Developer")
    "Pentest" = @("Standard","Wireshark","nmap", "advanced-ip-scanner","burp-suite-free-edition")
    "Developer" = @("python3", "nano", "filezilla", "gns3", "sysinternals", "winscp", "putty","winmerge","vscode")
    "Standard" = @("Minimal","virtualbox","vmwareworkstation","notepad++","vlc" )
    "Minimal" = @("googlechrome", "7zip","adobereader" )
}

if ($PackageSet -ne "Minimal") {
    $PackageList = $PackageSets.Values | ForEach-Object {$_}
}
else {
    $PackageList = $PackageSets[$PackageSet]
}
# -------------------------------------------------  Install Chocolatey -------------------------------------------------

## Change Directory to User Profile
Set-Location $env:USERPROFILE\Documents
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force

## Install Required Applications
if (-not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
    $script = New-Object Net.WebClient

    $script.DownloadString("https://chocolatey.org/install.ps1")

    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

    ## Upgrade Choco
choco upgrade chocolatey
choco feature enable -n allowGlobalConfirmation
}
# -------------------------------------------------  Install Python -------------------------------------------------
# Upgrade Python 
python -m pip install --upgrade pip

# Download VirtualBox API and Extract files
pip install virtualbox
pip install pyvbox

# -------------------------------------------------  Chocolatey Main Code -------------------------------------------------

# Loop over the package names and install or uninstall each package

if ($Uninstall) {
    Write-Host "Uninstalling packages:"
    foreach ($package in $PackageList) 
    {
        if (choco list -localonly | Select-String -SimpleMatch $package) {
            Write-Host "- $package"
            choco uninstall $package -y 
        } else {
            Write-Warning "$package is not installed."
        }
    }
} else {
    Write-Host "Installing packages:"
    foreach ($package in $PackageList) 
    {
        if (choco list -localonly | Select-String -SimpleMatch $package) {
            Write-Host "- $package"
        } else {
            Write-Host "- $package (not installed)"
        }
        choco install $package -y 
    }
}

# -------------------------------------------------  Install VMware PowerCLI -------------------------------------------------
if (-not (Test-Path "C:\Users\Vinnie\Documents\WindowsPowerShell\Modules\VMware.PowerCLI.Sdk")) {


}
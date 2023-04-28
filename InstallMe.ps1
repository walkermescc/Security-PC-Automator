[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("All","Standard","Minimal","Pentest","Developer")]
    [string]$PackageSet,
    [Parameter(Mandatory=$false)]
    [switch]$Uninstall
)

$PackageSets = @{
    "All" = @("Standard","Minimal","Pentest","Developer")
    "Pentest" = @("Standard","Pentest","Wireshark","nmap", "advanced-ip-scanner","burp-suite-free-edition")
    "Developer" = @("python3", "nano", "filezilla", "gns3", "sysinternals", "winscp", "putty","winmerge","vscode")
    "Standard" = @("Minimal","virtualbox","notepad++","vlc" )
    "Minimal" = @("googlechrome", "7zip","adobereader" )
}

if ($PackageSet -ne "Minimal") {
    $PackageList = $PackageSets.Values | ForEach-Object {$_}
}
else {
    $PackageList = $PackageSets[$PackageSet]
}

## Change Directory to User Profile
Set-Location $env:USERPROFILE\Documents
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force

## Install Choco
if (-not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
    $script = New-Object Net.WebClient

    $script.DownloadString("https://chocolatey.org/install.ps1")

    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

    ## Upgrade Choco
choco upgrade chocolatey
}


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

python -m pip install --upgrade pip

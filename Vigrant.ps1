# ------------------------------------------------- Information -------------------------------------------------
# Title - Install Vigrant Software
# Description - Powershell driven script, that downloads and installs Vigrant and then included a uninstall switch.
# Author - Vincent Walker
# Date - 28/04/2023

# ------------------------------------------------- Parameters -------------------------------------------------

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Mode
)

# ------------------------------------------------- Variables -------------------------------------------------

# This is a variable for Vigrant download section.
$url = "https://developer.hashicorp.com/vagrant/downloads"

# This is the location of the temporary files.
$downloadDirectory = "$env:APPDATA\Temp"

# Log Source
$Log = "Vigrant Script"

# ------------------------------------------------- Main Code -------------------------------------------------
if (-not (Get-EventLog -LogName "Application" -Source $Log)) {
New-EventLog -LogName "Application" -Source $Log
Write-Host "Eventlog required."
}
else {
    Write-Host "Eventlog not required."
}
if ($Mode -eq "Install") {
if (-not (Test-Path $downloadDirectory)) {
    try {
        Write-EventLog -LogName "Application" -EventId 2028 -Source $Log -Message "Making new directory: $downloadDirectory." -InformationAction Continue
        New-Item -Path $downloadDirectory -ItemType Directory -ErrorAction Stop | Out-Null
    }
    catch {
        Write-Error "Failed to create directory: $_"
    }
}

# Retrieve the link to the latest executable
$executableLink = $null
try {
    $executableLink = (Invoke-WebRequest -Uri $url -ErrorAction Stop).Links | 
        Where-Object { $_.href -like "*.exe" -or $_.href -like "*.msi" } | 
        Select-Object -ExpandProperty href | 
        Select-Object -First 1
        Write-EventLog -LogName "Application" -EventId 2028 -Source $Log -Message "Download URL has been generated: $executableLink" -InformationAction Continue

} catch {
    Write-Error "Failed to retrieve executable link: $_"
    return
}

if (-not $executableLink) {
    Write-Error "Could not find link to executable on page $url"
    return
}

# Download the latest executable
$executablePath = Join-Path -Path $downloadDirectory -ChildPath (Split-Path -Leaf $executableLink)
try {
    Invoke-WebRequest -Uri $executableLink -OutFile $executablePath -ErrorAction Stop
    Write-EventLog -LogName "Application" -EventId 2028 -Source $Log -Message "Download application: $executablePath" -InformationAction Continue

} catch {
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$($executablePath)`" /qn /norestart" -Wait -ErrorAction Stop   
    return
}

if (-not (Test-Path $executablePath)) {
    Write-Error "Downloaded executable path '$executablePath' does not exist."
    return
}

Write-Host "Downloaded executable path: $executablePath"

# Install or run the executable
if ($executablePath.EndsWith(".msi")) {
    try {
        Write-Host "Installing MSI: $executablePath"
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$executablePath`" /qn /norestart" -Wait -ErrorAction Stop
        Write-EventLog -LogName "Application" -EventId 2028 -Source $Log -Message "Install the application: $executablePath" -InformationAction Continue

    } catch {
        Write-Error "Failed to install MSI package '$executablePath': $_"
        return
    }
} else {
    try {
        Write-Host "Installing EXE: $executablePath"
        Start-Process -FilePath $executablePath -ErrorAction Stop
    } catch {
        Write-Error "Failed to run executable '$executablePath': $_"
        return
    }
}
}
else {
    if ($Mode -eq "Uninstall") {
        # Clean up the downloaded executable
            Write-Host "Uninstalling application: $executablePath"
            Start-Process -FilePath "msiexec.exe" -ArgumentList "/x `"$executablePath`" /qn /norestart" -Wait -ErrorAction Stop
            Write-Host "Remove temp file: $executablePath"
            Remove-Item -Path $executablePath -Force -ErrorAction Stop
            Write-EventLog -LogName "Application" -EventId 2028 -Source $Log -Message "The application Vigrant has been removed." -InformationAction Continue
    }
}

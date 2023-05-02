# Set the URL of the webpage containing the link to the latest executable
$url = "https://developer.hashicorp.com/vagrant/downloads"

# Set the directory where you want to save the downloaded executable
$downloadDirectory = "$env:APPDATA\Temp"

if ($Install)
if (-not (Test-Path $downloadDirectory)) {
    try {
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

# Clean up the downloaded executable
try {
    Remove-Item -Path $executablePath -Force -ErrorAction Stop
} catch {
    Write-Error "Failed to remove downloaded executable '$executablePath': $_"
    return
}

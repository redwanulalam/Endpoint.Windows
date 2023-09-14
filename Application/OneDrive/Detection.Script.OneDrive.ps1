$OneDriveInstalled = $false

# Check 32-bit Registry (Wow6432Node)
$Wow6432NodePath = 'HKLM:\Software\Wow6432Node'
$Wow6432NodeSubKeys = Get-ChildItem "$Wow6432NodePath\Microsoft\Windows\CurrentVersion\Uninstall"
$Wow6432NodeSubKeys += Get-ChildItem "$Wow6432NodePath\Microsoft\Windows\CurrentVersion\Uninstall\*"  # Additional subkeys

foreach ($subKey in $Wow6432NodeSubKeys) {
    $displayName = (Get-ItemProperty $subKey.PSPath).DisplayName
    if ($displayName -like '*OneDrive*') {
        $OneDriveInstalled = $true
        break
    }
}

# Check 64-bit Registry
$RegistryPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'
$RegistrySubKeys = Get-ChildItem "$RegistryPath\*"

foreach ($subKey in $RegistrySubKeys) {
    $displayName = (Get-ItemProperty $subKey.PSPath).DisplayName
    if ($displayName -like '*OneDrive*') {
        $OneDriveInstalled = $true
        break
    }
}

# Check if OneDrive is installed
if ($OneDriveInstalled) {
    Write-Host "OneDrive is installed."
    return 0
} else {
    Write-Host "OneDrive is not installed."
    return 1
}

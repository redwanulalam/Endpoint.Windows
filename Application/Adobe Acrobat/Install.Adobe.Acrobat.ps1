<#
.SYNOPSIS
Silently installs Adobe Acrobat Reader DC using Microsoft Intune.

.DESCRIPTION
This PowerShell script installs Adobe Acrobat Reader DC silently on a Windows system using Microsoft Intune. It checks if Adobe Acrobat Reader DC is already installed and exits if it is. If not, it downloads the installer, runs the installation with silent parameters, waits for the installation to finish, and cleans up the download.

Before using this script, ensure you have a valid Adobe Acrobat Reader DC Distribution Agreement in place, as detailed on the Adobe website: http://www.adobe.com/products/acrobat/distribute.html?readstep

If you need to use adobe_prtk to provision an installation package go here:
[URL: https://www.adobe.com/devnet-docs/acrobatetk/tools/DesktopDeployment/cmdline.html]

Sample command: adobe_prtk --tool=VolumeSerialize --generate --serial="xxx8-x001-s793-23xx-38xx-257s" --leid="V7{}AcrobatESR-12-Win-GM" --regsuppress=ss --eulasuppress --locales="en_GB" --stream

#>

# Check if Adobe Acrobat Reader DC is already installed in the registry
$CheckADCReg = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | where {$_.DisplayName -like "Adobe Acrobat Reader DC*"}

# If Adobe Reader is already installed, exit the script
If ($CheckADCReg -ne $null) {
    Write-Host "Adobe Acrobat Reader DC is already installed. Exiting script."
    Exit
}

# Path for the temporary download folder. Script will run as system so no issues here
$Installdir = "c:\temp"
New-Item -Path $Installdir  -ItemType directory

# Download the installer from the Adobe website. Always check for new versions!!
$source = "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/2001320064/AcroRdrDC2001320064_en_US.exe"
$destination = "$Installdir\AcroRdrDC1800920044_en_US.exe"
Invoke-WebRequest $source -OutFile $destination

# Start the installation when the download is finished
Start-Process -FilePath "$Installdir\AcroRdrDC1800920044_en_US.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES"

# Wait for the installation to finish. Test the installation and time it yourself. I've set it to 240 seconds.
Start-Sleep -s 240

# Finish by cleaning up the download. I choose to leave c:\temp\ for future installations.
Remove-Item -Force $Installdir\AcroRdrDC*

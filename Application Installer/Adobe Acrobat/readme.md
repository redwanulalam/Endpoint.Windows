<#
.SYNOPSIS
Silently installs Adobe Acrobat Reader DC using Microsoft Intune.

.DESCRIPTION
This PowerShell script installs Adobe Acrobat Reader DC silently on a Windows system using Microsoft Intune. It checks if Adobe Acrobat Reader DC is already installed and exits if it is. If not, it downloads the installer, runs the installation with silent parameters, waits for the installation to finish, and cleans up the download.

Before using this script, ensure you have a valid Adobe Acrobat Reader DC Distribution Agreement in place, as detailed on the Adobe website: http://www.adobe.com/products/acrobat/distribute.html?readstep

#>

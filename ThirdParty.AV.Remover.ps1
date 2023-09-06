<#
.SYNOPSIS
This PowerShell script silently uninstalls various third-party antivirus and anti-malware software, leaving only Windows Defender enabled.

.DESCRIPTION
This script silently uninstalls common third-party antivirus and anti-malware software from a Windows environment. It also enables Windows Defender.

.NOTES
File Name      : Melicious.App.Remover.ps1
Prerequisite   : Run PowerShell as Administrator
Author         : Redwanul Alam
#>

# Mcafee LiveSafe
$mcAfeeLiveSafePaths = @(
    "C:\Program Files\McAfee\MSC\mcuihost.exe /body:misp://MSCJsRes.dll::uninstall.html /id:uninstall /quiet",
    "C:\Program Files\McAfee\MSC\mcuihost.exe /body=misp://MSCJsRes.dll::uninstall.html /id:uninstall /quiet",
    "C:\Program Files\McAfee\MSC\mcuihost.exe /body=misp://MSCJsRes.dll::uninstall.html /id:uninstall /quiet"
)

# Mcafee Safe Connect
$mcAfeeSafeConnectPaths = @(
    "C:\ProgramData\Package Cache\{9ce9ccba-86f5-4114-bf39-0c18cd8f24f9}\McAfeeSafeConnect.exe /uninstall /quiet",
    "C:\ProgramData\Package Cache\{2973b354-fb68-4cf9-a20a-5bf99895504b}\McAfeeSafeConnect.exe /uninstall /quiet",
    "C:\ProgramData\Package Cache\{B39D44D4-A903-477D-8386-DE9B9983B12B}\McAfeeSafeConnect.exe /uninstall /quiet"
)

# Mcafee Web Advisor
$mcAfeeWebAdvisorPaths = @(
    "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe /quiet",
    "MsiExec.exe /I{B39D44D4-A903-477D-8386-DE9B9983B12B} /qn"
)

# PC HelpSoft Driver Updater
$driverUpdaterPath = '"C:\Program Files (x86)\PC HelpSoft Driver Updater\unins000.exe" /VERYSILENT'

# WinRAR uninstall
$winRARPath = "C:\Program Files\WinRAR\uninstall.exe /SILENT"

# Utorrent Web
# $utorrentWebPath = '"C:\Users\Hermil\AppData\Roaming\uTorrent Web\Uninstall.exe"'

# Webroot
$webrootPath = "C:\Program Files\Webroot\WRSA.exe /uninstall /quiet"

# 360 Total Security
$security360Path = "C:\Program Files (x86)\360\Total Security\Uninstall.exe /SILENT"

# CCleaner
$ccleanerPath = "C:\Program Files\CCleaner\uninst.exe /SILENT"

# Malwarebytes
$malwarebytesPath = "C:\Program Files\Malwarebytes\Anti-Malware\unins000.exe /SILENT"

# Panda Security
$pandaPath = "C:\Program Files\Panda Security\Panda Security Protection\Setup.exe /uninstall /quiet"

# AVG Antivirus
$avgPath = "C:\Program Files\AVG\Antivirus\setup.exe /uninstall /quiet"

# Norton Antivirus
$nortonPath = '"C:\Program Files\Norton Security\NortonInstaller.exe" /uninstall /all /quiet'

# Kaspersky Antivirus
$kasperskyPath = '"C:\Program Files (x86)\Kaspersky Lab\Kaspersky Security Software\setup.exe" /uninstall /s /norestart'

# Avast Antivirus
$avastPath = '"C:\Program Files\AVAST Software\Avast\aswRunDll.exe" /x /silent'

# Bitdefender
$bitdefenderPath = '"C:\Program Files\Bitdefender\Bitdefender Security\bduninstall.exe" /silent'

# ESET NOD32
$esetNod32Path = '"C:\Program Files\ESET\ESET Security\ecmd.exe" /uninstall /silent'

# Sophos
$sophosPath = '"C:\Program Files\Sophos\Sophos Endpoint Agent\uninstallcli.exe" --quiet'

# Trend Micro
$trendMicroPath = '"C:\Program Files\Trend Micro\AMSP\core\module\TmRemove.exe" /S /q'

# Windows Security Essentials (Microsoft Security Essentials)
$securityEssentialsPath = '"C:\Program Files\Microsoft Security Client\Setup.exe" /x /s'

# PC HelpSoft Driver Updater
$psHDUPath = '"C:\Program Files (x86)\PC HelpSoft Driver Updater\unins000.exe" --quiet'

# WinRAR
$winRARPath = '"C:\Program Files\WinRAR\uninstall.exe" --quiet'

# Utorrent Web
$utWebPath = '"C:\Users\Hermil\AppData\Roaming\uTorrent Web\Uninstall.exe" --quiet'

# Bing bar
$bingBarPath = 'MsiExec.exe /X "{3611CA6C-5FCA-4900-A329-6A118123CCFC}" /qn'

# Combine all paths
$allPaths = $mcAfeeLiveSafePaths + $mcAfeeSafeConnectPaths + $mcAfeeWebAdvisorPaths + $driverUpdaterPath + 
            $winRARPath + $webrootPath + $security360Path + $ccleanerPath + $malwarebytesPath + $pandaPath + 
            $avgPath + $nortonPath + $kasperskyPath + $avastPath + $bitdefenderPath + $esetNod32Path + 
            $sophosPath + $trendMicroPath + $securityEssentialsPath + $psHDUPath + $utWebPath + $bingBarPath

# Loop through paths and execute silent uninstallation commands
foreach ($path in $allPaths) {
    Start-Process -Wait -FilePath "cmd.exe" -ArgumentList "/c $path"
}

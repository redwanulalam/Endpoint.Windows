$SEARCH = '*LabTech*'
$INSTALLED = Get-ItemProperty 'HKLM:\Software\Wow6432Node\LabTech\*' | Select-Object DisplayName, UninstallString
$INSTALLED += Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, UninstallString
$RESULT = $INSTALLED | Where-Object { $_.DisplayName -like $SEARCH }

$SEARCH2 = '*ConnectWise Automate Remote Agent*'
$INSTALLED2 += Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, UninstallString
$RESULT2 = $INSTALLED2 | Where-Object { $_.DisplayName -like $SEARCH2 }

$SEARCH3 = '*ScreenConnect Client*'
$INSTALLED3 += Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, UninstallString
$RESULT3 = $INSTALLED3 | Where-Object { $_.DisplayName -like $SEARCH3 }

if ($RESULT -or $RESULT2 -or $RESULT3) {
    return 0
} else {
    return 1
}

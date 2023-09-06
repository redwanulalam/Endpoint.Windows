$SEARCH = '*Chrome*'
$INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
$INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
$RESULT = $INSTALLED | Where-Object { $_.DisplayName -like $SEARCH }

if ($RESULT) {
    return 0
} else {
    return 1
}

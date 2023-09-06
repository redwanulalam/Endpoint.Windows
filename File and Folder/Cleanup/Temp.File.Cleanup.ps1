<#
.SYNOPSIS
Automates the Windows Disk Cleanup tool for selected cleanup sections.

.DESCRIPTION
This PowerShell script automates the Windows Disk Cleanup tool for selected cleanup sections. It clears unnecessary files to free up disk space. You can specify which cleanup sections to include in the cleanup.

.PARAMETER Section
An array of cleanup sections to include. By default, all sections are included.

.EXAMPLE
.\Cleanup-Script.ps1 -Section 'Recycle Bin', 'Temporary Files'
This example runs the script and includes only the 'Recycle Bin' and 'Temporary Files' cleanup sections.

.NOTES
Author: Redwanul Alam (redwan@gmail.com)
#>

param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$Section = @(
        'Active Setup Temp Folders',
    'D3D Shader Cache',
    'BranchCache',
    'Content Indexer Cleaner',
    'Device Driver Packages',
    'Delivery Optimization Files',
    'Diagnostic Data Viewer database files', 
    'Downloaded Program Files',
    'Feedback Hub Archive log files', 
    'GameNewsFiles',
    'GameStatisticsFiles',
    'GameUpdateFiles',
    'Internet Cache Files',
    'Language Pack',
    'Memory Dump Files',
    'Offline Pages Files',
    'Old ChkDsk Files',
    'Previous Installations',
    'Recycle Bin',
    'RetailDemo Offline Content',
    'Service Pack Cleanup',
    'Setup Log Files',
    'System error memory dump files',
    'System error minidump files',
    'Temporary Files',
    'Temporary Setup Files',
    'Temporary Sync Files',
    'Thumbnail Cache',
    'Update Cleanup',
    'Upgrade Discarded Files',
    'User file versions',
    'Windows Defender',
    'Windows Error Reporting Files', 
    'Windows Error Reporting Archive Files',
    'Windows Error Reporting Queue Files',
    'Windows Error Reporting System Archive Files',
    'Windows Error Reporting System Queue Files',
    'Windows ESD installation files',
    'Windows Reset Log Files',
    'Windows Upgrade Log Files'
    )
)

# Clear CleanMgr.exe automation settings
$getItemParams = @{
    Path        = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\*'
    Name        = 'StateFlags0001'
    ErrorAction = 'SilentlyContinue'
}
Get-ItemProperty @getItemParams | Remove-ItemProperty -Name StateFlags0001 -ErrorAction SilentlyContinue

# Add enabled disk cleanup sections
foreach ($keyName in $Section) {
    $newItemParams = @{
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$keyName"
        Name         = 'StateFlags0001'
        Value        = 3
        PropertyType = 'DWord'
        ErrorAction  = 'SilentlyContinue'
    }
    $null = New-ItemProperty @newItemParams
}

# Start CleanMgr.exe
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1' -NoNewWindow -Wait

# Wait for CleanMgr and DismHost processes
Get-Process -Name cleanmgr, dismhost -ErrorAction SilentlyContinue | Wait-Process

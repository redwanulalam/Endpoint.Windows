#Uninstall Google Chrome from system
$SEARCH = 'chrome$'
$INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, UninstallString
$INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
$RESULT = $INSTALLED | ?{ $_.DisplayName -ne $null } | Where-Object {$_.DisplayName -match $SEARCH } 
if ($RESULT.uninstallstring -like "msiexec*") {
$ARGS=(($RESULT.UninstallString -split ' ')[1] -replace '/I','/X ') + ' /q'
Start-Process msiexec.exe -ArgumentList $ARGS -Wait
} else {
$UNINSTALL_COMMAND=(($RESULT.UninstallString -split '\"')[1])
$UNINSTALL_ARGS=(($RESULT.UninstallString -split '\"')[2]) + ' --force-uninstall'
Start-Process $UNINSTALL_COMMAND -ArgumentList $UNINSTALL_ARGS -Wait
}


# Function to uninstall Chrome from a user profile silently
function Uninstall-ChromeFromUserProfileSilent {
    param (
        [string]$profilePath
    )

    $chromePath = Join-Path $profilePath "AppData\Local\Google\Chrome\Application"
    $chromeExe = Join-Path $chromePath "chrome.exe"

    # Check if Chrome executable exists in the profile
    if (Test-Path $chromeExe) {
        try {
            # Uninstall Chrome silently
            $uninstallArgs = "/uninstall /silent"
            $process = Start-Process -FilePath $chromeExe -ArgumentList $uninstallArgs -PassThru -Wait
            $exitCode = $process.ExitCode

            # Check the uninstallation result
            if ($exitCode -eq 0) {
                Write-Host "Google Chrome has been successfully uninstalled from $($profilePath | Split-Path -Leaf) (silent)."
            } else {
                Write-Host "Failed to uninstall Google Chrome from $($profilePath | Split-Path -Leaf) (silent). Exit code: $exitCode"
            }
        } catch {
            Write-Host "An error occurred while uninstalling Google Chrome from $($profilePath | Split-Path -Leaf). Error: $_"
        }
    } else {
        Write-Host "Google Chrome is not installed in $($profilePath | Split-Path -Leaf)."
    }
}

# Get all user profiles
$userProfiles = Get-ChildItem "C:\Users" | Where-Object { $_.PSIsContainer }

# Loop through each user profile and uninstall Chrome silently
foreach ($userProfile in $userProfiles) {
    Uninstall-ChromeFromUserProfileSilent $userProfile.FullName
}

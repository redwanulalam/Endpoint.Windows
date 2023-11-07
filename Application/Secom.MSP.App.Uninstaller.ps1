# Define a list of uninstall commands
$uninstallCommands = @(
    "C:\Program Files\N-able Technologies\EndpointSetupInformation\{d5a9cecf-f510-42a3-20ce-ce14bffbb996}\installer.exe /uninstall /s",
    "C:\Program Files (x86)\MspPlatform\RequestHandlerAgent\unins000.exe /SILENT",
    "C:\Program Files (x86)\MspPlatform\PME\unins000.exe /SILENT",
    "C:\Program Files (x86)\MspPlatform\FileCacheServiceAgent\unins000.exe /SILENT",
    "C:\Program Files (x86)\SolarWinds MSP\Ecosystem Agent\unins000.exe /SILENT",
    "MsiExec.exe /X{70B16586-E15A-4917-B452-DF3B843F572D} /qn",
    "MsiExec.exe /X{9905E4C1-14D8-4522-88FE-FD00B51A20DC} /qn",
    "MsiExec.exe /X{FDBD3690-6FEF-4D4A-B35C-B3BBE7D878E3} /qn",
    "MsiExec.exe /X{8E1926E3-DF14-4CC5-855B-820948749818} /qn",
    "MsiExec.exe /X{304559BE-BE12-4E06-A6FC-953D0EA1F0E1} /qn",
    "C:\Program Files (x86)\MspPlatform\FileCacheServiceAgent\unins000.exe /SILENT",
    "C:\Program Files\N-able Technologies\EndpointSetupInformation\{d5a9cecf-f510-42a3-20ce-ce14bffbb996}\installer.exe /uninstall /s",
    "C:\Program Files\Google\Drive File Stream\83.0.2.0\uninstall.exe /S",
    "MsiExec.exe /X{C17F6DEF-D34C-4B75-97E1-D81062408B4A} /qn"
)

# Run the uninstallers
foreach ($command in $uninstallCommands) {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $command" -NoNewWindow -Wait
}

# Set the path where your files are stored
$FilePath = "D:\Tech Success\Clients - Documents\Accountancy Insurance\Technical\Installed Application Report"

# Set the path for the output CSV file
$OutputCsvPath = "D:\Tech Success\Clients - Documents\Accountancy Insurance\Technical\Installed Application Report\Unique_Applications_Full.csv"

# Create an empty list to store all application objects
$AllApplicationObjects = New-Object System.Collections.ArrayList

# Get all CSV files in the specified path and loop through each one
Get-ChildItem -Path $FilePath -Filter "*.csv" | ForEach-Object {
    
    # Import the CSV data from the current file
    $data = Import-Csv -Path $_.FullName

    # Find the correct column name for the application name
    $appNameColumn = $null
    $possibleNames = "Name", "DisplayName", "Application Name"

    foreach ($name in $possibleNames) {
        if ($data | Get-Member -Name $name) {
            $appNameColumn = $name
            break
        }
    }
    
    # If a valid column is found, add the entire objects to our list
    if ($null -ne $appNameColumn) {
        $data | ForEach-Object {
            $AllApplicationObjects.Add($_) | Out-Null
        }
    } else {
        # If no valid column is found, report it
        Write-Host "Warning: No suitable application name column found in $($_.Name). Skipping this file." -ForegroundColor Yellow
    }
}

# The unique filter needs to work on a property. We'll group by the application name.
# The 'Select-Object -First 1' ensures we keep all properties of the first unique item found.
$uniqueApplications = $AllApplicationObjects | Group-Object -Property $appNameColumn | ForEach-Object {
    $_.Group | Select-Object -First 1
}

# Check if any unique applications were found
if ($uniqueApplications.Count -gt 0) {
    # Sort the list alphabetically by the application name column and export to CSV
    $uniqueApplications | Sort-Object -Property $appNameColumn | Export-Csv -Path $OutputCsvPath -NoTypeInformation

    Write-Host "Successfully exported a unique list of $($uniqueApplications.Count) applications to '$OutputCsvPath'" -ForegroundColor Green
} else {
    Write-Host "No unique applications were identified to export." -ForegroundColor Red
}

# Set the path where your files are stored
$FilePath = "D:\Tech Success\Clients - Documents\Accountancy Insurance\Technical\Installed Application Report\Workstations"

# Set the path for the output CSV file
$OutputCsvPath = "D:\Tech Success\Clients - Documents\Accountancy Insurance\Technical\Installed Application Report\Workstations\Unique_Applications_Full.csv"

# Create a list to hold all application objects from both file types
$AllApplicationObjects = New-Object System.Collections.ArrayList

# Find the correct column names for the application details
$appNameColumnName = "ApplicationName"
$appPublisherColumnName = "Publisher"
$appVersionColumnName = "Version"

# List of potential source column names to check for
$possibleNames = "Name", "DisplayName", "Application Name"
$possiblePublishers = "Publisher", "Publisher Name"
$possibleVersions = "Version", "DisplayVersion", "InstalledVersion"

# Get all CSV and XLSX files in the specified path, excluding the output file
# The -Recurse parameter is added to look in subfolders, which is a good practice.
# The path is now given a wildcard to ensure -Include works correctly.
$sourceFiles = Get-ChildItem -Path $FilePath -Recurse -Filter "*.csv" | Where-Object { $_.FullName -ne $OutputCsvPath }
$sourceFiles += Get-ChildItem -Path $FilePath -Recurse -Filter "*.xlsx" | Where-Object { $_.FullName -ne $OutputCsvPath }

# Check if any files were found
if ($sourceFiles.Count -eq 0) {
    Write-Host "No valid CSV or XLSX files found in the specified directory to process." -ForegroundColor Yellow
    exit
}

# Loop through each file and process it
foreach ($file in $sourceFiles) {
    Write-Host "Processing file: $($file.Name)" -ForegroundColor Cyan
    
    $data = $null

    # Process CSV files
    if ($file.Extension -eq ".csv") {
        $data = Import-Csv -Path $file.FullName
    }
    # Process XLSX files
    elseif ($file.Extension -eq ".xlsx") {
        try {
            $excel = New-Object -ComObject Excel.Application
            $excel.Visible = $false
            $excel.DisplayAlerts = $false
            
            $workbook = $excel.Workbooks.Open($file.FullName)
            $worksheet = $workbook.Worksheets.Item(1)
            $usedRange = $worksheet.UsedRange
            
            # Convert Excel data to a standard PowerShell object format
            $data = $usedRange.Rows | Select-Object -Skip 1 | ForEach-Object {
                $row = $_
                $newRow = New-Object PSObject
                for ($i = 1; $i -le $row.Cells.Count; $i++) {
                    $newRow | Add-Member -MemberType NoteProperty -Name ($usedRange.Cells.Item(1, $i).Value2) -Value ($row.Cells.Item($i).Value2)
                }
                $newRow
            }

            $workbook.Close($false)
            $excel.Quit()
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
            Remove-Variable -Name excel
            [gc]::Collect()
            [gc]::WaitForPendingFinalizers()

        } catch {
            Write-Host "Error processing XLSX file $($file.Name). Check if Microsoft Excel is installed." -ForegroundColor Red
            continue
        }
    }
    
    # After importing, standardise the properties for all objects
    if ($null -ne $data) {
        $data | ForEach-Object {
            $originalObject = $_
            $standardisedObject = [PSCustomObject]@{
                ApplicationName = $null
                Publisher = $null
                Version = $null
            }

            # Find and map the application name
            foreach ($name in $possibleNames) {
                if ($originalObject.psobject.Properties.Name -contains $name) {
                    $standardisedObject.ApplicationName = $originalObject.$name
                    break
                }
            }
            
            # Find and map the publisher name
            foreach ($publisher in $possiblePublishers) {
                if ($originalObject.psobject.Properties.Name -contains $publisher) {
                    $standardisedObject.Publisher = $originalObject.$publisher
                    break
                }
            }
            
            # Find and map the version
            foreach ($version in $possibleVersions) {
                if ($originalObject.psobject.Properties.Name -contains $version) {
                    $standardisedObject.Version = $originalObject.$version
                    break
                }
            }
            
            # Add the new, standardised object to our master list
            $AllApplicationObjects.Add($standardisedObject) | Out-Null
        }
    }
}

# The unique filter needs to work on a consistent property name.
$uniqueApplications = $AllApplicationObjects | Group-Object -Property $appNameColumnName | ForEach-Object {
    $_.Group | Select-Object -First 1
}

# Check if any unique applications were found
if ($uniqueApplications.Count -gt 0) {
    $uniqueApplications | Sort-Object -Property $appNameColumnName | Export-Csv -Path $OutputCsvPath -NoTypeInformation
    
    Write-Host "Successfully exported a unique list of $($uniqueApplications.Count) applications to '$OutputCsvPath'" -ForegroundColor Green
} else {
    Write-Host "No unique applications were identified to export." -ForegroundColor Red
}

# # Check if parameters are provided; if not, ask for them
# if ($PSBoundParameters.Count -ne 3) {
#     $FilePath = Read-Host "Enter the full path to the file"
#     $DestinationPath = Read-Host "Enter the destination path"
#     $Passkey = Read-Host "Enter the passkey"
# }
# else {
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string[]]$FilePaths, # Accept an array of file paths

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$DestinationPath,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$Passkey
)
# }


if (-not (Test-Path $DestinationPath)) {
    Write-Error "🔻 Destination path is not accessible: $DestinationPath"
    return
}else {
    Write-Host "✅ DestinationPath is validated"
}


# Validate Passkey (example: Passkey must be "Secret123")
$expectedPasskey = "i know what i'm doing"  # Replace with your actual expected passkey

if ($Passkey -ne $expectedPasskey) {
    Write-Error "🔻 Incorrect Passkey."
    return
} else {
    Write-Host "✅ Passkey is validated"
}

foreach ($FilePath in $FilePaths) {
    # Add Download path if FilePath is just a filename
    $FileName = ''
    if (-not ($FilePath -match '\\') -and -not ($FilePath -match ':')) { #Check if it's a full path.
        $FileName = $FilePath 
        $DownloadPath = "$env:USERPROFILE\Downloads"  # Get the user's Downloads folder
        $FilePath = Join-Path $DownloadPath $FilePath
        Write-Host "✱ add Download location."

    }

    # Check if the file exists
    if (-not (Test-Path $FilePath)) {
        Write-Error "🔻 File not found: $FilePath"
        return
    } else {
        Write-Host "✅ FilePath is validated"
    }

    # Backup the original file (append .bak)
    $backupPath = "$FilePath.bak"
    if (-not (Test-Path $backupPath)) {
        Copy-Item $FilePath $backupPath #-Force
        Write-Host "✅ Backed up"
    } else {
        Write-Host "✱ Backup is already existed"
    }

    # # Read the file content
    # try {
    #     $content = Get-Content $FilePath -Raw
    # }
    # catch {
    #     Write-Error "Error reading file: $_"
    #     return
    # }

    # Replace specific characters (using the Passkey)

    # Write the modified content back to the file
    try {
        $content = Get-Content $FilePath -Raw
        # $replacedContent = $content -replace "`"", "" -replace "`|0`|","`|`|" #Add more replace lines as needed.
        $content = "labno|urno|name1|name2|address|dob|sex|medicare|veteran|pension|location|collected`r`n$content"
        Write-Host "✅ Add headers"

        $replacedContent = $content.replace('"', '').replace('|0|', '||').TrimEnd("`r`n")
        Set-Content $FilePath -Value $replacedContent -Encoding UTF8
        Write-Host "✅ Removed `"  , replaced |0| -> ||"
    }
    catch {
        Write-Error "🔻 Error writing to file: $_"
        return
    }

    # try {
    #     # Start-Process -FilePath "wsl" -ArgumentList "ping -W 500 -c 1 google.com" -Wait -NoNewWindow
    #     $pattern1 = 's/\"//g' # Replace with your sed pattern
    #     $arg1 = "sed -i -E `"$pattern1`" ./Downloads/$FileName"
    #     Start-Process -FilePath "wsl" -ArgumentList $arg1 -Wait -NoNewWindow
    #     Write-Host "`u{2705} Applied: $arg1"

    #     $pattern2 = 's/\|0\|/\|\|/g' # Replace with your sed pattern
    #     $arg2 = "sed -i -E `"$pattern2`" ./Downloads/$FileName"
    #     Start-Process -FilePath "wsl" -ArgumentList $arg1 -Wait -NoNewWindow
    #     Write-Host "`u{2705} Applied: $arg2"
    # }
    # catch {
    #     Write-Host "`u{274C} Error executing command: $_"
    #     # Write-Host "`u{274C} Error executing command: $_"
    # }

    # $input = Read-Host "✱✱✱ Please check the output. Press Enter when it's good to go, or any other key to abort"
    # if ($input -ne "") {
    #     Write-Host "🔻 Aborting script."
    #     Write-Host ""

    #     return # Exit the script
    # }

    # Copy the modified file to the destination
    try {
        Write-Host "⏳ Start copying file..."
        Copy-Item $FilePath $DestinationPath -Force
    }
    catch {
        Write-Error "🔻 Error copying file to destination: $_"
        return
    }

    Write-Host "🏆 File processed and copied successfully"
    Write-Host ""
}

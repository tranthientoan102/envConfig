# Script to manage the 'vEthernet (WSL)' network adapter

# Step 1: Collect current IP and save into a variable
$adapterName = "vEthernet (WSL)"
$currentIPObject = Get-NetIPAddress -InterfaceAlias $adapterName -AddressFamily IPv4 | Where-Object {$_.PrefixOrigin -ne "WellKnown"}

if (-not $currentIPObject) {
    Write-Error "Could not find a valid IPv4 address for '$adapterName'."
    exit 1
}

$currentIP = $currentIPObject.IPAddress

Write-Host "Current IP: $currentIP"

# Step 2: Modify network adapter's IP with new IP (current IP + 1) and network mask.
$ipParts = $currentIP.Split(".")
$lastPart = [int]$ipParts[3]
$newLastPart = $lastPart + 1
$newIP = "$($ipParts[0]).$($ipParts[1]).$($ipParts[2]).$newLastPart"
$newPrefixLength = 8 # 255.0.0.0 is equivalent to a /8 prefix length

try {
    Remove-NetIPAddress -InterfaceAlias $adapterName -IPAddress $currentIP -Confirm:$false -ErrorAction Stop
    New-NetIPAddress -InterfaceAlias $adapterName -IPAddress $newIP -PrefixLength $newPrefixLength -AddressFamily IPv4 -ErrorAction Stop
    Write-Host "IP modified to: $newIP, Network Mask: 255.0.0.0"
} catch {
    Write-Error "Failed to modify IP: $_"
    exit 1
}

# Step 3: Wait 10 seconds
Write-Host "Waiting 10 seconds..."
Start-Sleep -Seconds 10

# Step 4: Modify network adapter's IP back to original IP and network mask.
try {
    Remove-NetIPAddress -InterfaceAlias $adapterName -IPAddress $newIP -Confirm:$false -ErrorAction Stop
    New-NetIPAddress -InterfaceAlias $adapterName -IPAddress $currentIP -PrefixLength $newPrefixLength -AddressFamily IPv4 -ErrorAction Stop
    Write-Host "IP reverted to original: $currentIP, Network Mask: 255.0.0.0"
} catch {
    Write-Error "Failed to revert IP: $_"
}

# Wait for Enter to exit
Write-Host "Press Enter to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
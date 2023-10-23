param(
    [Parameter(Mandatory = $true)]
    [string]$username,

    [Parameter(Mandatory = $true)]
    [string]$password
)
if ($username -eq "_") {
   
    Write-Verbose "ERR: No SSRS user specified"
    exit 1
}

if ($password -eq "_") {
  if (Test-Path $env:ssrs_password_path) {
    $password = Get-Content -Raw $secretPath
  }
  else {
    Write-Verbose "ERR: No SSrs user password specified and secret file not found at: $secretPath"
    exit 1
  }
}

$secpass = ConvertTo-SecureString  -AsPlainText $password -Force

Try {
  $existingUser = Get-LocalUser $username -ErrorAction Stop # | Get-Member -ErrorAction Stop
} Catch {
  Write-Host "User $username does not exist yet, creating..."
}

if ($existingUser.Length -eq 0) {
    Write-Host "Creating user $username"
    New-LocalUser "$username" -Password $secpass -FullName "$username" -Description "Local admin $username"
    Add-LocalGroupMember -Group "Administrators" -Member "$username"
    Get-LocalGroupMember -Group "Administrators"
} else {
    Write-Host "User $username already exists, skipping creation."
    Write-Information "test"
}


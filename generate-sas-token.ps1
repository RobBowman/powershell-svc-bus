# Note: this script is called by post-msg.ps1
[CmdletBinding()]
param (
    [Parameter()]
    $Namespace = "biztalkers",
    [Parameter()]
    $EntityPath = "p4f",
    [Parameter()]
    $SasKeyName = "RootManageSharedAccessKey",
    [Parameter()]
    $SasKey = "get-sas-key-from-azure-portal"

)

# Define the token's time-to-live in seconds
$ttl = New-TimeSpan -Days 30

# Get the target URI
$targetUri = [System.Web.HttpUtility]::UrlEncode("https://$Namespace.servicebus.windows.net/$EntityPath")

# Get the expiry time
$expiry = [DateTimeOffset]::Now.ToUnixTimeSeconds() + $ttl.TotalSeconds

# Generate the string to sign
$stringToSign = $targetUri + "`n" + $expiry

# Generate the signature
$hmac = New-Object System.Security.Cryptography.HMACSHA256
$hmac.Key = [Text.Encoding]::ASCII.GetBytes($SasKey)
$signature = $hmac.ComputeHash([Text.Encoding]::ASCII.GetBytes($stringToSign))
$signature = [Convert]::ToBase64String($signature)

# Generate the SAS token
$encodedSignature = [System.Web.HttpUtility]::UrlEncode($signature)
$sasToken = "sr=$targetUri&sig=$encodedSignature&se=$expiry&skn=$SasKeyName"

# Output the SAS token
$sasToken
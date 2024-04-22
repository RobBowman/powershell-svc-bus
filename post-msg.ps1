# This is the entry point. It will call the generate-sas-token.ps1 script to generate a SAS token and then use it to send a message to an Azure Service Bus topic.

# Define your connection string, topic name and SAS token
$endpoint = "https://biztalkers.servicebus.windows.net/"
$topicName = "p4f"
$sasToken = & '.\generate-sas-token.ps1'
$authHeader = "SharedAccessSignature $sasToken"

# Read JSON content from the file
$jsonFilePath = "./msg.json"
$jsonContent = Get-Content $jsonFilePath -Raw | ConvertFrom-Json

# Replace eventid and correlationid with new GUIDs
$jsonContent.eventid = [guid]::NewGuid().ToString()
$jsonContent.correlationid = [guid]::NewGuid().ToString()

# Convert the updated object back to JSON
$jsonContent = $jsonContent | ConvertTo-Json -Depth 100

# Output the JSON content
$jsonContent

# Prepare the custom properties
$properties = @{
    "eventtype" = "CommsEnrichmentCommand"
    "sourcesystem" = "Workflow"
}

# Convert properties to JSON
$propertiesJson = $properties | ConvertTo-Json -Compress

# Prepare the headers
$headers = @{
    "Authorization" = $authHeader
    "Content-Type" = "application/json"
    "BrokerProperties" = $propertiesJson
}

# Send the message using Invoke-RestMethod and store the response
$response = Invoke-RestMethod -Uri "$endpoint$topicName/messages" -Method Post -Body $jsonContent -Headers $headers

# Output the response
$response
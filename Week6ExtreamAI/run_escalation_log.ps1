param (
    [string]$inputFile = "data/low.json"
)

Write-Host "Using input file: $inputFile"

# Ensure logs folder exists
if (!(Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Generate request ID
$request_id = [guid]::NewGuid().ToString()

# Read input JSON
$inputData = Get-Content $inputFile | ConvertFrom-Json
$risk = $inputData.input.risk_level
$agent = $inputData.input.agent_id
$prompt = $inputData.input.prompt_id

# Call OPA API
$response = curl.exe -X POST "http://localhost:8181/v1/data/audit/decision" `
  -H "Content-Type: application/json" `
  --data-binary "@$inputFile"

# Determine decision
if ($response -match "allow") {
    $decision = "allow"
}
elseif ($response -match "escalate") {
    $decision = "escalate"
}
else {
    $decision = "block"
}

# Map escalation level
if ($risk -eq "low" -or $risk -eq "medium") {
    $escalation = "auto_approve"
    $status = "approved"
}
elseif ($risk -eq "high") {
    $escalation = "manual_review"
    $status = "pending"
}
else {
    $escalation = "blocked"
    $status = "rejected"
}

# Timestamp
$timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Create escalation log
$logObject = @{
    request_id = $request_id
    timestamp = $timestamp
    agent_id = $agent
    prompt_id = $prompt
    risk_level = $risk
    decision = $decision
    escalation_level = $escalation
    status = $status
}

# Convert to clean JSON
$logJson = $logObject | ConvertTo-Json -Depth 3

# Save log
Add-Content -Path "logs/escalation_logs.json" -Value $logJson
Add-Content -Path "logs/escalation_logs.json" -Value "`n"

Write-Host "✅ Escalation log saved successfully!"
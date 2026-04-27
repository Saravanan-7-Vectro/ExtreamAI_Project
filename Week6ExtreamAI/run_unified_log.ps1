param (
    [string]$inputFile = "data/low.json"
)

Write-Host "Running Unified Logging..."

# Ensure logs folder exists
if (!(Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Generate request ID
$request_id = [guid]::NewGuid().ToString()

# Read input
$inputData = Get-Content $inputFile | ConvertFrom-Json

$risk = $inputData.input.risk_level
$agent = $inputData.input.agent_id
$prompt = $inputData.input.prompt_id
$action = $inputData.input.action

# Call OPA
$response = curl.exe -X POST "http://localhost:8181/v1/data/audit/decision" `
  -H "Content-Type: application/json" `
  --data-binary "@$inputFile"

# Decision + Reason + Rule
if ($response -match "allow") {
    $decision = "allow"
    $reason = "Low/Medium risk allowed"
    $rule = "allow_low_medium"
}
elseif ($response -match "escalate") {
    $decision = "escalate"
    $reason = "High risk requires review"
    $rule = "escalate_high"
}
else {
    $decision = "block"
    $reason = "Default deny"
    $rule = "default_block"
}

# Escalation Mapping
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

# Unified Log
$logObject = @{
    request_id = $request_id
    timestamp = $timestamp
    agent_id = $agent
    prompt_id = $prompt
    risk_level = $risk
    action = $action

    decision = $decision
    reason = $reason
    rule_applied = $rule

    escalation_level = $escalation
    status = $status
}

# Convert JSON
$logJson = $logObject | ConvertTo-Json -Depth 3

# Save
Add-Content -Path "logs/unified_logs.json" -Value $logJson
Add-Content -Path "logs/unified_logs.json" -Value "`n"

Write-Host "✅ Unified log saved!"
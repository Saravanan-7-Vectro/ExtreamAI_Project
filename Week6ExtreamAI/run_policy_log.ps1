Write-Host "Calling OPA for decision..."

# Ensure logs folder exists
if (!(Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Generate unique request ID
$request_id = [guid]::NewGuid().ToString()

# Call OPA API
$response = curl.exe -X POST "http://localhost:8181/v1/data/audit/decision" `
  -H "Content-Type: application/json" `
  --data-binary "@data/input.json"

# Decide based on response
if ($response -match "allow") {
    $decision = "allow"
    $reason = "Low/Medium risk allowed"
    $rule = "allow_low_medium"
}
elseif ($response -match "escalate") {
    $decision = "escalate"
    $reason = "High risk requires manual review"
    $rule = "escalate_high"
}
else {
    $decision = "block"
    $reason = "Default deny (safety policy)"
    $rule = "default_block"
}

# Clean timestamp
$timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Create structured log object
$logObject = @{
    request_id = $request_id
    timestamp = $timestamp
    agent_id = "agent_001"
    prompt_id = "prompt_001"
    risk_level = "test"
    decision = $decision
    reason = $reason
    rule_applied = $rule
}

# Convert to pretty JSON (NOT compressed)
$logJson = $logObject | ConvertTo-Json -Depth 3

# Save log with spacing
Add-Content -Path "logs/policy_logs.json" -Value $logJson
Add-Content -Path "logs/policy_logs.json" -Value "`n"

Write-Host "✅ Policy log saved successfully!"
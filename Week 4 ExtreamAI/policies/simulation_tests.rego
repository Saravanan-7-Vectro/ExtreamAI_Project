package ai.simulation

default decision = "DENY"
default allowed = false

policy_id := "AI-GOV-001"

risk_score := 10 if input.risk_level == "Low"
risk_score := 40 if input.risk_level == "Medium"
risk_score := 70 if input.risk_level == "High"
risk_score := 95 if input.risk_level == "Critical"

decision := "ALLOW" if {
    input.risk_level == "Low"
}

decision := "ALLOW" if {
    input.risk_level == "Medium"
}

decision := "APPROVAL_REQUIRED" if {
    input.risk_level == "High"
}

decision := "DENY" if {
    input.risk_level == "Critical"
}

allowed if decision == "ALLOW"

result := {
    "request_id": input.request_id,
    "policy_id": policy_id,
    "user": input.user,
    "action": input.action,
    "risk_level": input.risk_level,
    "risk_score": risk_score,
    "decision": decision,
    "allowed": allowed
}
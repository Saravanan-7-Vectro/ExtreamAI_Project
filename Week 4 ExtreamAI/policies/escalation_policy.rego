package ai.escalation

default escalation = "BLOCK"
default decision = "DENY"

policy_id := "AI-GOV-ESC-002"

# Risk Score Mapping
risk_score := 10 if input.risk_level == "Low"
risk_score := 40 if input.risk_level == "Medium"
risk_score := 70 if input.risk_level == "High"
risk_score := 95 if input.risk_level == "Critical"

# Escalation Levels
escalation := "AUTO_APPROVE" if input.risk_level == "Low"
escalation := "MANUAL_REVIEW" if input.risk_level == "Medium"
escalation := "MANUAL_REVIEW" if input.risk_level == "High"
escalation := "BLOCK" if input.risk_level == "Critical"

# Final Decision
decision := "APPROVED" if escalation == "AUTO_APPROVE"
decision := "PENDING_REVIEW" if escalation == "MANUAL_REVIEW"
decision := "REJECTED" if escalation == "BLOCK"

result := {
    "request_id": input.request_id,
    "policy_id": policy_id,
    "user": input.user,
    "action": input.action,
    "risk_level": input.risk_level,
    "risk_score": risk_score,
    "escalation_level": escalation,
    "final_decision": decision
}
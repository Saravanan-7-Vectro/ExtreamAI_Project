package ai.governance

default result = {
    "decision": "blocked",
    "reason": "Action not allowed by policy"
}

# LOW risk allowed
result := {
    "decision": "allowed",
    "reason": "Low risk action allowed",
    "agent_id": input.metadata.agent_id
} if input.metadata.risk_level == "low"

# MEDIUM risk allowed
result := {
    "decision": "allowed",
    "reason": "Medium risk action allowed",
    "agent_id": input.metadata.agent_id
} if input.metadata.risk_level == "medium"

# HIGH risk allowed only with approval
result := {
    "decision": "allowed",
    "reason": "High risk approved",
    "agent_id": input.metadata.agent_id
} if {
    input.metadata.risk_level == "high"
    input.metadata.approval_required == true
}

# HIGH risk blocked without approval
result := {
    "decision": "blocked",
    "reason": "High risk action requires approval",
    "agent_id": input.metadata.agent_id
} if {
    input.metadata.risk_level == "high"
    input.metadata.approval_required == false
}

# CRITICAL risk always blocked
result := {
    "decision": "blocked",
    "reason": "Critical risk action blocked",
    "agent_id": input.metadata.agent_id
} if input.metadata.risk_level == "critical"
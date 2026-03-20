package ai.governance

default allow := false

allow if input.risk_level == "Low"

allow if input.risk_level == "Medium"

allow if {
    input.risk_level == "High"
    input.approval == true
}

deny if input.risk_level == "Critical"
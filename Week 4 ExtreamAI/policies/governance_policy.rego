package ai.governance

default decision = {
    "allowed": false,
    "status": "DENY",
    "reason": "Policy evaluation not satisfied"
}

decision := {
    "allowed": true,
    "status": "ALLOW",
    "reason": "Low risk action permitted"
} if {
    input.risk_level == "Low"
}

decision := {
    "allowed": true,
    "status": "ALLOW",
    "reason": "Medium risk action permitted with monitoring"
} if {
    input.risk_level == "Medium"
}

decision := {
    "allowed": false,
    "status": "APPROVAL_REQUIRED",
    "reason": "High risk action requires supervisor approval"
} if {
    input.risk_level == "High"
    not input.approval
}

decision := {
    "allowed": true,
    "status": "ALLOW",
    "reason": "High risk approved by supervisor"
} if {
    input.risk_level == "High"
    input.approval == true
}

decision := {
    "allowed": false,
    "status": "DENY",
    "reason": "Critical risk action blocked by governance policy"
} if {
    input.risk_level == "Critical"
}
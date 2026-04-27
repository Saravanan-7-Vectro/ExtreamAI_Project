package audit

default decision = "block"

decision := "allow" if {
    input.risk_level == "low"
}

decision := "allow" if {
    input.risk_level == "medium"
}

decision := "escalate" if {
    input.risk_level == "high"
}
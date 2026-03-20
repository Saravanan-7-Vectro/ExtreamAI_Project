{
    "result": [
        {
            "allowed": false,
            "decision": "APPROVAL_REQUIRED",
            "reason": "High risk action requires supervisor approval",
            "risk_level": "High",
            "scenario": "System Configuration Change"
        },
        {
            "allowed": false,
            "decision": "DENY",
            "reason": "Critical risk action blocked by governance policy",
            "risk_level": "Critical",
            "scenario": "Database Deletion"
        },
        {
            "allowed": true,
            "decision": "ALLOW",
            "reason": "Low risk action permitted",
            "risk_level": "Low",
            "scenario": "Document Summary"
        },
        {
            "allowed": true,
            "decision": "ALLOW",
            "reason": "Low risk action permitted",
            "risk_level": "Low",
            "scenario": "Report Generation"
        },
        {
            "allowed": true,
            "decision": "ALLOW",
            "reason": "Medium risk action permitted with monitoring",
            "risk_level": "Medium",
            "scenario": "Internal Data Access"
        }
    ]
}

| Scenario             | Expected Decision | Actual Decision   | Result |
| -------------------- | ----------------- | ----------------- | ------ |
| Report Generation    | Allow             | Allow             | PASS   |
| Document Summary     | Allow             | Allow             | PASS   |
| Internal Data Access | Allow             | Allow             | PASS   |
| System Configuration | Approval Required | Approval Required | PASS   |
| Database Deletion    | Deny              | Deny              | PASS   |

User Prompt
     ↓
AI Agent
     ↓
Governance Metadata
     ↓
OPA Policy Engine
     ↓
Governance Decision
     ↓
Action Execution
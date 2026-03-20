import json
from datetime import datetime
import uuid

log_file = "../logs/audit_log.json"

def create_log(prompt, agent_id, risk_level, action, decision):

    log_entry = {
        "log_id": str(uuid.uuid4()),
        "timestamp": datetime.utcnow().isoformat(),
        "prompt_input": prompt,
        "agent_id": agent_id,
        "risk_level": risk_level,
        "action": action,
        "decision": decision
    }

    try:
        with open(log_file, "r") as f:
            logs = json.load(f)
    except:
        logs = []

    logs.append(log_entry)

    with open(log_file, "w") as f:
        json.dump(logs, f, indent=4)

    print("Log saved successfully")


create_log(
    prompt="Delete customer records",
    agent_id="agent_finance_01",
    risk_level="high",
    action="database_delete",
    decision="blocked"
)
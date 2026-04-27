

# 📄 **WEEK 5 – Audit Logging

---

## 🔹 **Objective**

To create a system that **automatically records logs** for every agent execution in a **structured format**.

---

## 🔹 **Audit Log Schema**

We defined a standard format to store logs:

```json
{
  "timestamp": "time of execution",
  "agent_id": "agent id",
  "prompt_id": "prompt id",
  "risk_level": "low/medium/high/critical",
  "action": "requested action",
  "result": "success/failure",
  "approval_required": true/false
}
```

---

## 🔹 **How Logging Works**

1. Input is given (agent + prompt + risk)
2. Policy is checked using OPA
3. Decision is made
4. Execution happens
5. Log is automatically created

---

## 🔹 **Log Storage**

* Logs are saved in:

```
execution_logs.json
```

* Stored in **JSON format**
* Logs are **append-only** (no deletion)

---

## 🔹 **Sample Log**

```json
{
  "timestamp": "2026-04-06T16:10:00Z",
  "agent_id": "agent_001",
  "prompt_id": "prompt_001",
  "risk_level": "low",
  "action": "summarize",
  "result": "success",
  "approval_required": false
}
```

---

## 🔹 **Validation**

Tested with different inputs:

* Low → success
* Medium → success
* High → needs approval
* Critical → blocked

Logs were correct for all cases.

---

## 🔹 **Outcome**

✔ Standard log format created
✔ Logs generated automatically
✔ Stored in structured JSON
✔ Multiple cases tested
✔ Ready for next phase

---



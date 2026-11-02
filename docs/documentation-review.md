# Documentation Review Register

This register captures possible documentation inconsistencies identified while preparing Portuguese translations. It is separate from the translated documents and from validated laboratory evidence.

**Scope reviewed:** main `README.md`, with cross-checks against Stage 00 and Stage 01 documentation and the completed-stage summaries.

**Review date:** 2026-11-01

**Review status:** findings recorded for later technical verification; no corrective changes made to the original English documentation.

| ID | Location | Observation | Suggested follow-up | Status |
|---|---|---|---|---|
| DOC-001 | `README.md` — Project Purpose | The phrase "Each stage includes implementation, validation, controlled failure simulation, troubleshooting, recovery..." may imply that every completed stage included a controlled fault and recovery. Stage 00 is a read-only workstation baseline, not a fault-injection exercise. | Clarify the generic statement with "where applicable" or distinguish baseline stages from fault-injection stages. | Review pending |
| DOC-002 | `README.md` — Incident Scenarios | "The laboratory reproduces scenarios" introduces a list including low disk space, packet loss, and false positives. The completed-stage summaries do not clearly establish controlled reproduction of every listed scenario. The list can be read as a completion claim rather than an overview of supported or planned scenarios. | Verify each scenario against lab evidence; separate validated scenarios from examples or planned exercises. | Review pending |
| DOC-003 | `labs/00-workstation-validation/README.md` — Planned Platform Allocation | The initial allocation lists the Linux monitored host as a "Lightweight container", whereas the implemented Stage 02 uses Ubuntu 24.04 LTS under WSL 2. This is explainable as a change between planning and implementation, but it could confuse readers. | Preserve the historical baseline and explicitly note the subsequently implemented WSL 2 approach if a revision is approved. | Review pending |

## Review rules

- The original English files and the Portuguese translation remain unchanged by these findings.
- These observations are documentation-review candidates, not verified functional defects.
- Laboratory status, numerical results, and evidence must only be updated after verification.
- Any future corrections to the source documentation should be made in separate, traceable commits.
- Keep translations synchronized with approved source corrections in subsequent commits.

# Documentation Review Register

This register captures possible documentation inconsistencies identified while preparing Portuguese translations. It is separate from the translated documents and from validated laboratory evidence.

**Scope reviewed:** main `README.md`, full Stage 00 and Stage 01 documentation (`labs/00-workstation-validation/README.md`, `labs/01-zabbix-platform/README.md`), the associated validation script (`scripts/powershell/validate-workstation.ps1`), current `compose.yaml`, `.env.example`, and completed-stage summaries.

**Review date:** 2026-11-01

**Review status:** findings recorded for later technical verification; no corrective changes made to the original English documentation.

| ID | Location | Observation | Suggested follow-up | Status |
|---|---|---|---|---|
| DOC-001 | `README.md` — Project Purpose | The phrase "Each stage includes implementation, validation, controlled failure simulation, troubleshooting, recovery..." may imply that every completed stage included a controlled fault and recovery. Stage 00 is a read-only workstation baseline, not a fault-injection exercise. | Clarify the generic statement with "where applicable" or distinguish baseline stages from fault-injection stages. | Review pending |
| DOC-002 | `README.md` — Incident Scenarios | "The laboratory reproduces scenarios" introduces a list including low disk space, packet loss, and false positives. The completed-stage summaries do not clearly establish controlled reproduction of every listed scenario. The list can be read as a completion claim rather than an overview of supported or planned scenarios. | Verify each scenario against lab evidence; separate validated scenarios from examples or planned exercises. | Review pending |
| DOC-003 | `labs/00-workstation-validation/README.md` — Planned Platform Allocation | The initial allocation lists the Linux monitored host as a "Lightweight container", whereas the implemented Stage 02 uses Ubuntu 24.04 LTS under WSL 2. This is explainable as a change between planning and implementation, but it could confuse readers. | Preserve the historical baseline and explicitly note the subsequently implemented WSL 2 approach if a revision is approved. | Review pending |
| DOC-004 | `labs/00-workstation-validation/README.md` — Required Ports | The table reports baseline availability for TCP `8080`, `8443`, `10050`, `10051`, `5432`, `80`, and `443`. The tracked `validate-workstation.ps1` checks local listening ports only for `8080`, `8443`, `10050`, and `10051`; its outbound TCP `443` test measures remote connectivity, not local port availability. The other baseline port claims may have been verified separately, but that evidence was not identified in the script. | Confirm whether the additional local port checks were performed separately, document their evidence or clarify the table as a planning inventory; do not retroactively change historical results without verification. | Review pending |
| DOC-005 | `labs/00-workstation-validation/README.md` — Evidence | The evidence section states that the Git repository was "clean and synchronized". The tracked script checks whether it is inside a repository and records the current branch, but does not run a working-tree cleanliness or remote-sync check. Additional manual evidence may exist. | Confirm separate evidence of clean/synchronized state or narrow this claim to what the script demonstrably checked. | Review pending |
| DOC-006 | `labs/01-zabbix-platform/README.md` — Deployment / Platform Validation / Architecture | Stage 01 describes the historical three-service platform (PostgreSQL, Zabbix Server and Zabbix Web), two loopback-published ports, and an unrestricted `docker compose --env-file .env up -d` command. The current `compose.yaml` also includes `monitored-web`, `snmp-target` and `mailpit`, publishes further loopback endpoints for Mailpit and SNMP, and needs the corresponding SNMP variables/build context. Running the documented command on the present default branch therefore does not reproduce the Stage 01-only deployment exactly. | Preserve the Stage 01 historical results; consider documenting the Compose revision used for that stage or a safe three-service invocation and the differences from the current stack. Validate any revised procedure before publishing it. | Review pending |
| DOC-007 | `labs/01-zabbix-platform/README.md` — Outcome | The final sentence says Stage 02 "will add" a Linux host, even though Stage 02 has already been completed and documented. This is valid as historical roadmap language but is potentially misleading in the current repository context. | Clarify the chronology in a future source-document revision (e.g., note that Stage 02 was subsequently implemented); keep the translation faithful until that change is approved. | Review pending |

## Review rules

- The original English files and the Portuguese translation remain unchanged by these findings.
- These observations are documentation-review candidates, not verified functional defects.
- Laboratory status, numerical results, and evidence must only be updated after verification.
- Any future corrections to the source documentation should be made in separate, traceable commits.
- Keep translations synchronized with approved source corrections in subsequent commits.

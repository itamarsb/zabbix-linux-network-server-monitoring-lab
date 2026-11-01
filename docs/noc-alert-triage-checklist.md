# NOC Alert Triage Checklist

[Back to repository](../README.md)

> **Purpose:** quick-reference checklist for NOC operators handling Zabbix alerts. It complements the validated Stage 05–08 procedures; this document is a reusable operational aid, not evidence that a new incident test has been executed.

**Workflow:** Detect → Validate → Classify → Acknowledge → Diagnose → Escalate or Restore → Verify → Document.

## 1. Alert intake and validation

- [ ] Open **Monitoring → Problems** in Zabbix; record the event time, problem/event ID, host, trigger, and current status.
- [ ] Identify the affected service, asset, monitoring signal (item), and the first observed symptom.
- [ ] Verify that the event is still current: compare **Latest data**, recent graphs, item timestamps, and problem history.
- [ ] Check for related alerts and shared dependencies; distinguish one failed check from a broader incident.
- [ ] Check whether the host or problem is under **planned maintenance or suppression** before initiating notifications.
- [ ] Confirm whether a notification action actually executed. A problem event does **not** by itself prove a message was sent.
- [ ] Record any missing, delayed, or unsupported monitoring data instead of treating it as a healthy zero.

**Initial record:** `Event ID: ____ | Host/service: ____ | Started (date/time zone): ____ | Current status: ____ | Operator: ____`

## 2. Severity and impact assessment

- [ ] Read the configured Zabbix severity; do not assume it equals the business priority.
- [ ] Assess user/customer impact, affected services, scope, duration, critical dependencies, and available workarounds.
- [ ] Evaluate whether multiple hosts or sites are affected, and whether the impact is expanding.
- [ ] Prioritize using the organization's response policy. Escalate promptly for critical service impact even when the trigger severity is lower.

| Zabbix trigger severity | Initial operator action |
|:---:|:---|
| **Disaster / High** | Prioritize immediate validation and escalation according to impact and the response policy. |
| **Average** | Investigate promptly, check service impact, and escalate if the incident expands or exceeds authority. |
| **Warning** | Validate the signal and trend; assess whether service degradation or a preventive action is required. |
| **Information / Not classified** | Confirm the event context and document or route it as appropriate. |

> These are triage guidelines, **not** fixed SLA targets. Severity, paging, and escalation deadlines must come from an approved operating policy.

## 3. Read-only first diagnosis

- [ ] Compare the latest measurements with the pre-incident baseline and other independent signals.
- [ ] Check host/agent availability, recent configuration or deployment changes, and correlated events.
- [ ] Select relevant read-only checks; record results and timestamps before any intervention.

| Symptom | First checks | Related lab |
|:---:|:---|:---:|
| HTTP or TCP failure | Response code, failed step, port reachability, service/container status | [Stage 04](../labs/04-network-service-monitoring/README.md) |
| DNS failure | Name resolution, resolver, target, recent changes; compare monitored value | [Stage 05](../labs/05-triggers-alert-handling/README.md) |
| Host or agent unavailable | Agent status, network path, recent data, dependent services | [Stages 02–03](../labs/02-linux-host-monitoring/README.md) |
| SNMP collection failure | Item freshness, target reachability, interface state, credentials/configuration **without revealing secrets** | [Stage 08](../labs/08-snmp-grafana-integration/README.md) |
| Alert without email | Media type, action conditions, user media severity, Zabbix action log, Mailpit (lab only) | [Stage 06](../labs/06-alert-delivery-notifications/README.md) |
| Alert during maintenance | Maintenance scope, active period, suppressed problem, expected notification behavior | [Stage 07](../labs/07-maintenance-operational-reporting/README.md) |

- [ ] Distinguish **observed fact**, **working hypothesis**, and **unverified cause** in the incident notes.
- [ ] If the alert is a false positive or monitoring fault, document the evidence; do not disable checks simply to clear the queue.

## 4. Acknowledgment, communication, and escalation

- [ ] Acknowledge the problem in Zabbix **when ownership/triage has actually been accepted**, and add an operator note.
- [ ] Create or update the incident/ticket record using the team's standard process.
- [ ] Escalate immediately when there is major impact, possible security exposure, a safety concern, uncertain blast radius, or missing authority/access.
- [ ] Escalate to the appropriate NOC L2/L3, application, infrastructure, network, cloud, or security team when needed.
- [ ] Include in the handoff: event ID, host/service, start time, impact, severity, monitoring evidence, actions performed, hypotheses, and next owner.
- [ ] Record who accepted the escalation and when. Maintain agreed updates while the incident is active.

> **Do not** restart services, change production configurations, mute alerts, rotate credentials, or perform destructive commands without the required authorization and rollback plan.

## 5. Mitigation and recovery

- [ ] Confirm the selected mitigation is approved, limited in scope, and has a rollback option.
- [ ] Record each action, operator, timestamp, expected result, and observed outcome.
- [ ] Check the service from the **consumer/system perspective** (for example, HTTP response or reachable port).
- [ ] Independently verify the **monitoring perspective**: fresh item values, trigger transition, graphs, and event state.
- [ ] Verify recovery of dependent services and whether related problems remain open.
- [ ] Verify notification and recovery-message execution separately, when that action is configured and applicable.
- [ ] Do not mark recovery complete solely because an event disappeared or was manually closed.

## 6. Closure and shift handover

- [ ] Record detection time, acknowledgment time, escalation time, mitigation time, and recovery confirmation time (with time zone).
- [ ] Document root cause **only if established**; otherwise record current findings and pending investigation.
- [ ] Capture sanitized evidence and document any residual risks or follow-up work.
- [ ] Confirm that temporary changes or test conditions have been reverted and maintenance windows closed when applicable.
- [ ] Close the ticket only under the team's closure criteria; identify unresolved items and the next responsible team.
- [ ] If work crosses a shift boundary, prepare a handover with current status, actions taken, pending checks, and escalation contacts.

**Closure record:** `Impact: ____ | Evidence: ____ | Mitigation: ____ | Recovery verified at: ____ | Pending actions/owner: ____`

## Related validated material

- [Stage 05 — Triggers, severities and acknowledgment](../labs/05-triggers-alert-handling/README.md)
- [Stage 06 — Notification delivery and action-log troubleshooting](../labs/06-alert-delivery-notifications/README.md)
- [Stage 07 — Planned maintenance and operational reporting](../labs/07-maintenance-operational-reporting/README.md)
- [Stage 07 — Shift handover example](../labs/07-maintenance-operational-reporting/shift-handover-report.md)
- [Stage 08 — SNMP monitoring and recovery](../labs/08-snmp-grafana-integration/README.md)

**Security note:** never commit credentials, SNMP communities, access tokens, private keys, sensitive event payloads, or unredacted screenshots. The Stage 08 optional SNMP notification action was not validated and remains disabled; do not assume that every SNMP incident produces an email.

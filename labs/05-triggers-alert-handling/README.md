# Stage 05 - Triggers, Severities, Events, and Alert Handling

[Back to the main README](../../README.md)

## Objective

This stage introduces trigger configuration, severity classification, event generation, problem acknowledgment, operator notes, and initial alert-handling workflows.

The implementation uses the monitoring signals established in the previous stages to reproduce common Network Operations Center activities:

- converting monitoring data into actionable alerts;
- reducing false positives through sustained-condition expressions;
- assigning operational severity according to service impact;
- identifying active problems in the Zabbix frontend;
- acknowledging incidents;
- recording operator findings and actions;
- validating automatic recovery;
- preserving event history after service restoration.

## Current Status

Stage 05 is in progress.

The first complete trigger and alert-handling lifecycle has been successfully validated.

The controlled HTTP incident demonstrated:

- initial trigger state `OK`;
- isolated interruption of the dedicated HTTP target;
- sustained failure detection;
- automatic transition from `OK` to `PROBLEM`;
- high-severity incident visibility;
- operator acknowledgment;
- operational triage documentation;
- explicit escalation decision;
- controlled service restoration;
- successful container health validation;
- automatic transition from `PROBLEM` to `RESOLVED`;
- preservation of the incident and action history.

Additional trigger and severity scenarios will be introduced before the stage is marked as complete.

## Operational Context

Monitoring items collect values, but a Network Operations Center requires defined conditions that determine when those values represent operational problems.

A trigger converts collected monitoring data into an event when its expression evaluates to true.

The validated workflow follows this sequence:

```text
Normal monitoring
    -> Sustained service failure
    -> Trigger evaluation
    -> PROBLEM event
    -> Operator validation
    -> Acknowledgment
    -> Investigation
    -> Recovery action
    -> RESOLVED event
    -> Operational record
```

The objective is not only to display a problem. The stage demonstrates the complete alert lifecycle from detection through recovery.

## Severity Model

The laboratory uses the Zabbix severity levels according to expected operational impact.

| Severity | Intended use |
|---|---|
| Not classified | Conditions without an established operational classification |
| Information | Informational state changes that do not require immediate action |
| Warning | Degraded behavior or an early indication of possible impact |
| Average | A relevant problem with limited or moderate operational impact |
| High | Service unavailability or a significant condition requiring prompt investigation |
| Disaster | Critical platform or infrastructure failure with extensive impact |

Severity is assigned according to the monitored service and expected impact rather than only the technical type of failure.

## Initial HTTP Trigger

The first trigger monitors the dedicated HTTP target created during Stage 04.

| Property | Configured value |
|---|---|
| Host | `Internal Services - Zabbix Lab` |
| Trigger name | `Monitored web service is unavailable` |
| Event name | `HTTP service unavailable on monitored-web` |
| Monitored item | `Monitored web TCP service availability` |
| Item key | `net.tcp.service[tcp,monitored-web,80]` |
| Severity | `High` |
| Evaluation window | `2m` |
| Normal value | `1` |
| Problem condition | TCP availability remains `0` for two minutes |
| Recovery method | Automatic expression-based recovery |
| Initial state | `OK` |

The generated trigger expression is:

```text
max(/Internal Services - Zabbix Lab/net.tcp.service[tcp,monitored-web,80],2m)=0
```

The two-minute evaluation window prevents a single transient collection failure from immediately opening an operational incident.

## Operational Data

The trigger displays the most recent TCP availability value through:

```text
Current TCP availability: {ITEM.LASTVALUE1}
```

Expected values:

| Value | Meaning |
|:---:|---|
| `1` | TCP port is reachable |
| `0` | TCP port is unavailable |

## Trigger Description

The configured operational description is:

```text
The dedicated monitored HTTP service is unavailable on TCP port 80. Validate Docker service state, internal DNS resolution, container health, and network connectivity before escalation.
```

This description provides the initial investigation scope without prescribing an unverified root cause.

## Initial Validation

The trigger was successfully created and validated in the Zabbix frontend.

Initial results:

- the trigger was accepted by Zabbix;
- the generated expression references the correct internal host name;
- the monitored TCP item is valid;
- severity is configured as `High`;
- the trigger is enabled;
- the initial trigger value was `OK`;
- automatic expression-based recovery is enabled;
- incident generation mode is set to `Single`.

### Initial trigger evidence

![Initial HTTP trigger in OK state](../../docs/screenshots/stage-05-http-trigger-initial-ok.png)

The evidence confirms the enabled trigger, `High` severity, sustained-condition expression, and initial `OK` state.

## Controlled HTTP Incident

The dedicated `monitored-web` container was selected as the controlled failure target.

This target was appropriate because:

- it is isolated from the Zabbix platform;
- it does not store monitoring data;
- it can be stopped without interrupting PostgreSQL;
- it can be restored independently;
- its failure is monitored through TCP and HTTP checks.

The controlled interruption was performed with:

```powershell
docker compose --env-file .env stop monitored-web
```

The environment was then validated with:

```powershell
docker compose --env-file .env ps
```

The resulting state confirmed:

- `monitored-web` was stopped;
- PostgreSQL remained healthy;
- Zabbix Server remained operational;
- Zabbix Web remained healthy;
- no unrelated container was interrupted.

### Controlled service-stop evidence

![Controlled HTTP service stop](../../docs/screenshots/stage-05-controlled-http-service-stop.png)

The evidence confirms the isolated interruption and preservation of the essential monitoring platform services.

## Problem Detection

After the sustained two-minute failure condition was satisfied, Zabbix generated the expected problem event.

| Event property | Observed value |
|---|---|
| Problem time | `21:57:19` |
| Host | `Zabbix Lab Internal Services` |
| Event | `HTTP service unavailable on monitored-web` |
| Severity | `High` |
| Initial status | `PROBLEM` |
| Acknowledgment state | Not acknowledged |
| Monitored service | `monitored-web:80` |

The event confirmed that the trigger converted the TCP availability signal into an actionable high-severity incident.

### Problem-detection evidence

![HTTP problem detected](../../docs/screenshots/stage-05-http-problem-detected.png)

The evidence confirms the high-severity `PROBLEM` event created by the controlled service interruption.

## Acknowledgment and Operational Triage

The incident was acknowledged by the operator after validating its scope and platform impact.

The following operational note was recorded:

```text
Initial triage completed. The dedicated monitored-web service is confirmed unavailable during a controlled laboratory test. PostgreSQL, Zabbix Server, and Zabbix Web remain operational. Investigation is limited to the isolated HTTP target. Escalation is not required, and service recovery is authorized within the laboratory scope.
```

The note records:

- confirmation that the service was unavailable;
- validation that the failure was isolated;
- preservation of PostgreSQL and Zabbix services;
- limitation of the investigation scope;
- the decision not to escalate;
- authorization to restore the service.

No manual incident closure was performed. Recovery remained dependent on the trigger expression returning to its normal state.

### Acknowledgment evidence

![Acknowledged HTTP problem and operational note](../../docs/screenshots/stage-05-http-problem-acknowledged.png)

The evidence preserves the operator, timestamp, acknowledgment action, and complete operational triage note.

## Controlled Service Recovery

The dedicated HTTP target was restored with:

```powershell
docker compose --env-file .env start monitored-web
```

The immediate Compose state showed that the container had started and its health check was initializing.

### Service-recovery initiation evidence

![Controlled HTTP service recovery](../../docs/screenshots/stage-05-controlled-http-service-recovery.png)

The evidence records the controlled start of `monitored-web` and preservation of the other platform services during recovery.

A subsequent Compose validation confirmed:

- `monitored-web` was running and healthy;
- PostgreSQL remained healthy;
- Zabbix Server remained operational;
- Zabbix Web remained healthy.

### Final service-health evidence

![HTTP service health validation](../../docs/screenshots/stage-05-http-service-health-validation.png)

The evidence confirms the final healthy state of the restored service and the complete Docker Compose platform.

## Automatic Trigger Recovery

After the monitored TCP value returned to `1`, the trigger expression automatically returned to its normal state.

| Recovery property | Observed value |
|---|---|
| Problem time | `21:57:19` |
| Recovery time | `22:29:15` |
| Final status | `RESOLVED` |
| Recorded duration | `31m 56s` |
| Recovery method | Automatic trigger-expression recovery |
| Manual closure | Not used |
| Acknowledgment preserved | Yes |
| Operational note preserved | Yes |

The incident lifecycle therefore completed as:

```text
OK -> PROBLEM -> ACKNOWLEDGED -> RESOLVED
```

### Automatic-recovery evidence

![HTTP problem automatically recovered](../../docs/screenshots/stage-05-http-problem-recovered.png)

The evidence confirms the recovery timestamp, final `RESOLVED` state, event duration, and preserved acknowledgment indicators.

## Validated Alert-Handling Workflow

The completed validation included:

1. confirmation that the trigger was enabled and initially `OK`;
2. isolated interruption of the `monitored-web` service;
3. sustained failure detection;
4. creation of the high-severity `PROBLEM` event;
5. validation of the incident scope;
6. acknowledgment by the operator;
7. recording of an operational investigation note;
8. documentation of the escalation decision;
9. controlled restoration of the HTTP service;
10. validation of the container health check;
11. automatic transition to `RESOLVED`;
12. preservation of the complete event history;
13. storage of selected technical evidence.

## Troubleshooting Notes

### Host-name validation

The visible host name and the internal host name used by trigger expressions were not identical.

The expression initially referenced:

```text
Zabbix Lab Internal Services
```

Zabbix rejected that manual expression because the internal host name is:

```text
Internal Services - Zabbix Lab
```

The expression builder was used to select the monitored item and generate the correct expression automatically.

This approach prevents invalid expressions caused by differences between visible and internal host names.

### Recovery health transition

Immediately after the container was started, Docker Compose reported:

```text
health: starting
```

This state was expected while the Nginx health check initialized.

A later validation confirmed:

```text
healthy
```

Zabbix independently confirmed service recovery when the monitored TCP value returned to `1` and the incident changed automatically to `RESOLVED`.

### Unrelated existing incidents

The Zabbix problem view also displayed unrelated Windows service and historical Linux Agent incidents.

These events were not modified during the HTTP test because they were outside the controlled incident scope.

## Evidence Summary

| Evidence | File |
|---|---|
| Initial trigger in `OK` state | `stage-05-http-trigger-initial-ok.png` |
| Controlled service interruption | `stage-05-controlled-http-service-stop.png` |
| High-severity problem detection | `stage-05-http-problem-detected.png` |
| Acknowledgment and operational note | `stage-05-http-problem-acknowledged.png` |
| Controlled service-recovery initiation | `stage-05-controlled-http-service-recovery.png` |
| Final healthy container state | `stage-05-http-service-health-validation.png` |
| Automatic trigger recovery | `stage-05-http-problem-recovered.png` |

## Acceptance Criteria

Stage 05 will be complete when:

- [x] the initial HTTP service-availability trigger is created;
- [x] the trigger uses a sustained two-minute failure condition;
- [x] the trigger is assigned `High` severity;
- [x] the trigger is enabled and initially reports `OK`;
- [x] a controlled service failure generates a `PROBLEM` event;
- [x] the problem appears with the expected severity;
- [x] the event identifies the affected host and service;
- [x] the problem is acknowledged;
- [x] an operational investigation note is recorded;
- [x] an initial escalation decision is documented;
- [x] the monitored service is restored;
- [x] the container returns to a healthy state;
- [x] the trigger automatically returns to its normal state;
- [x] the incident is displayed as `RESOLVED`;
- [x] the event history preserves the failure and recovery lifecycle;
- [x] selected HTTP incident evidence is stored;
- [ ] an additional trigger with a different severity is configured;
- [ ] the additional trigger behavior is validated;
- [ ] final Stage 05 results are documented.

## Next Steps

The next activity will configure an additional service trigger with a different operational severity to demonstrate severity classification beyond the initial high-severity HTTP outage.

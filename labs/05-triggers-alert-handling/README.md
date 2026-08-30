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

The initial HTTP service-availability trigger has been created and remains in the normal `OK` state.

The next activities will validate:

- controlled transition from `OK` to `PROBLEM`;
- severity visibility in the monitoring interface;
- problem acknowledgment;
- operational notes;
- initial triage and escalation decisions;
- service recovery;
- automatic transition from `PROBLEM` back to `OK`;
- preservation of the complete event history.

## Operational Context

Monitoring items collect values, but a Network Operations Center requires defined conditions that determine when those values represent operational problems.

A trigger converts collected monitoring data into an event when its expression evaluates to true.

The initial workflow follows this sequence:

```text
Normal monitoring
    -> Sustained service failure
    -> Trigger evaluation
    -> PROBLEM event
    -> Operator validation
    -> Acknowledgment
    -> Investigation
    -> Recovery action
    -> OK event
    -> Operational record
```

The objective is not only to display a problem. The stage must demonstrate the complete alert lifecycle from detection through recovery.

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

## Initial Trigger

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
- the current trigger value is `OK`;
- automatic expression-based recovery is enabled;
- incident generation mode is set to `Single`.

## Planned Controlled Incident

The dedicated `monitored-web` container will be used as the controlled failure target.

This target is appropriate because:

- it is isolated from the Zabbix platform;
- it does not store monitoring data;
- it can be stopped without interrupting PostgreSQL;
- it can be restored independently;
- its failure is already monitored through TCP and HTTP checks.

The controlled incident must preserve:

- PostgreSQL availability;
- Zabbix Server availability;
- Zabbix Web availability;
- Windows and Linux host monitoring;
- unrelated Docker resources.

## Planned Alert-Handling Workflow

The controlled validation will include:

1. confirm the trigger is enabled and currently `OK`;
2. stop only the `monitored-web` service;
3. wait for the sustained failure condition;
4. confirm creation of the `PROBLEM` event;
5. validate the displayed severity and operational data;
6. acknowledge the problem;
7. add an operational investigation note;
8. validate related monitoring data;
9. restore the dedicated HTTP service;
10. confirm automatic recovery to `OK`;
11. review the complete event and acknowledgment history;
12. preserve selected technical evidence.

## Evidence Plan

Only evidence that demonstrates meaningful operational results will be committed.

Planned evidence includes:

- the active trigger in the normal `OK` state;
- the trigger-generated `PROBLEM` event;
- the acknowledged problem with an operational note;
- related TCP and HTTP monitoring data during the incident;
- the automatic recovery event;
- the complete problem and recovery history.

Screenshots containing credentials, personal information, unrelated desktop content, or unnecessary interface elements must not be committed.

## Acceptance Criteria

Stage 05 will be complete when:

- [x] the initial HTTP service-availability trigger is created;
- [x] the trigger uses a sustained two-minute failure condition;
- [x] the trigger is assigned `High` severity;
- [x] the trigger is enabled and initially reports `OK`;
- [ ] a controlled service failure generates a `PROBLEM` event;
- [ ] the problem appears with the expected severity;
- [ ] the event displays the current operational value;
- [ ] the problem is acknowledged;
- [ ] an operational investigation note is recorded;
- [ ] an initial escalation decision is documented;
- [ ] the monitored service is restored;
- [ ] the trigger automatically returns to `OK`;
- [ ] the event history preserves the failure and recovery lifecycle;
- [ ] selected Stage 05 evidence is stored;
- [ ] final troubleshooting notes and results are documented.

## Next Steps

The next activity will perform a controlled interruption of only the `monitored-web` service and validate the transition from `OK` to `PROBLEM`.

# Stage 07 - Maintenance Windows and Operational Reporting

[Back to the main README](../../README.md)

## Objective

This stage introduces planned-maintenance handling and operational reporting practices commonly performed by Network Operations Center teams.

The implementation validates how Zabbix behaves when a monitored service is intentionally interrupted during an approved maintenance window.

The stage covers:

- planned maintenance configuration;
- host association with an active maintenance period;
- continued monitoring-data collection;
- controlled interruption of the monitored HTTP service;
- problem-event suppression during planned work;
- notification-suppression validation;
- service restoration;
- maintenance-window closure;
- post-maintenance health validation;
- operational maintenance documentation;
- incident-lifecycle recording;
- shift-handover reporting;
- troubleshooting notes and selected evidence.

## Current Status

**Completed**

Stage 07 successfully validated the complete planned-maintenance lifecycle for the `monitored-web` service.

The final implementation confirmed:

- creation of a maintenance period with data collection;
- association of the maintenance period with `Zabbix Lab Internal Services`;
- continued item and web-scenario data collection;
- controlled HTTP service interruption;
- generation of the expected problem event;
- problem suppression during the maintenance period;
- prevention of unintended Mailpit notifications;
- successful service restoration;
- automatic problem recovery;
- formal maintenance closure;
- removal of the host maintenance indicator;
- normal post-maintenance monitoring;
- preparation of maintenance and shift-handover records.

## Laboratory Components

| Component | Purpose | Maintenance impact |
|:---:|---|:---:|
| PostgreSQL | Zabbix configuration and history database | Remained available |
| Zabbix Server | Monitoring and event processing | Remained available |
| Zabbix Web | Configuration and incident validation | Remained available |
| Mailpit | Local notification capture | Remained available |
| `monitored-web` | Controlled HTTP monitoring target | Intentionally interrupted |
| `Zabbix Lab Internal Services` | Logical host for internal service monitoring | Placed under maintenance |

## Pre-Maintenance Baseline

The initial validation confirmed:

- PostgreSQL was healthy;
- Zabbix Server was running;
- Zabbix Web was healthy and returned HTTP status `200`;
- Mailpit was healthy and returned HTTP status `200`;
- the monitored HTTP container was healthy;
- monitored-web TCP availability was `1`;
- the HTTP scenario returned status code `200`;
- the HTTP scenario had no failed step;
- no active HTTP incident existed for `Zabbix Lab Internal Services`;
- the Mailpit mailbox contained zero messages.

Unrelated Windows service and Ubuntu WSL agent incidents were present in the environment, but they did not affect the selected maintenance target.

## Maintenance Target

| Field | Value |
|---|:---:|
| Change identifier | `CHG-LAB-007` |
| Zabbix host | `Zabbix Lab Internal Services` |
| Service | `monitored-web` |
| Monitoring signal | HTTP service availability |
| Expected normal TCP value | `1` |
| Controlled action | Temporary container stop |
| Maintenance type | With data collection |
| Notification expectation | No maintenance-related notification |
| Recovery expectation | Service returns to the normal state |

## Maintenance Configuration

A dedicated Zabbix maintenance period was created for the controlled activity.

| Setting | Value |
|:---:|---|
| Name | `NOC Lab - Monitored Web Planned Maintenance` |
| Maintenance type | With data collection |
| Associated host | `Zabbix Lab Internal Services` |
| Schedule type | One time only |
| Initial active period | September 4, 2026, from 19:25 to 21:30 |
| Test period | September 4, 2026, starting at 19:29 for one hour |
| Change reference | `CHG-LAB-007` |

The maintenance type allowed Zabbix to continue collecting item and web-scenario data while suppressing operational actions associated with the planned interruption.

![Active maintenance period](../../docs/screenshots/stage-07-active-maintenance-period.png)

## Notification-Suppression Configuration

The existing trigger action was reviewed before the controlled interruption:

`NOC Lab - Mailpit problem notifications`

The action option `Pause operations for suppressed incidents` was enabled.

This setting preserved the problem event in Zabbix while preventing the associated notification operation during the active maintenance period.

The Mailpit mailbox contained zero messages before the test.

## Maintenance Workflow

The following sequence was completed:

1. registered the planned activity as `CHG-LAB-007`;
2. configured a maintenance period in Zabbix;
3. associated `Zabbix Lab Internal Services` with the maintenance;
4. kept monitoring-data collection enabled;
5. confirmed that the maintenance period was active;
6. recorded the initial Mailpit message count;
7. stopped the `monitored-web` service intentionally;
8. validated the monitored TCP and HTTP failures;
9. confirmed creation of the suppressed problem event;
10. confirmed that no unnecessary notification reached Mailpit;
11. restored the monitored service;
12. validated TCP and HTTP recovery;
13. confirmed automatic problem resolution;
14. ended the maintenance period;
15. confirmed removal of the host maintenance state;
16. validated the normal post-maintenance platform state;
17. completed the maintenance and shift-handover records.

## Execution Timeline

| Time | Activity | Result |
|:---:|---|---|
| 19:25 | Maintenance became active | Host entered planned maintenance |
| 19:46:05 | Controlled test started | Mailpit contained zero messages |
| 19:46 | `monitored-web` was stopped | Controlled interruption began |
| 19:47:19 | HTTP problem was generated | High-severity incident created and suppressed |
| 19:49:08 | Suppression validation completed | Mailpit remained at zero messages |
| 19:52:36 | Service restoration started | `monitored-web` was started |
| 19:53:15 | HTTP problem recovered | Incident changed to `RESOLVED` |
| 19:58:58 | Recovery validation completed | Service and monitoring returned to normal |
| 20:04 | Maintenance period ended | Maintenance status changed to `Expired` |
| 20:05:30 | Final validation completed | Platform confirmed operational |

## Controlled Service Interruption

Only the `monitored-web` service was stopped.

The interruption produced the expected monitoring behavior:

| Monitoring signal | Expected during failure | Observed | Result |
|---|:---:|:---:|:---:|
| Monitored-web TCP availability | `0` | `0` | Passed |
| HTTP scenario failed step | `1` | `1` | Passed |
| PostgreSQL TCP availability | `1` | `1` | Passed |
| HTTP problem severity | High | High | Passed |
| Problem suppression | Enabled | Confirmed | Passed |

The remaining Docker services continued operating normally.

![Controlled HTTP unavailability](../../docs/screenshots/stage-07-controlled-http-unavailability.png)

## Suppressed Problem Validation

Zabbix generated the expected incident:

`HTTP service unavailable on monitored-web`

The incident was created at `19:47:19` with High severity.

The incident view confirmed:

- the problem was associated with `Zabbix Lab Internal Services`;
- the host was under active maintenance;
- the problem was marked as suppressed;
- the event remained available for operational review;
- monitoring data continued to be collected;
- notification operations were not executed.

![Suppressed HTTP problem](../../docs/screenshots/stage-07-suppressed-http-problem.png)

## Notification-Suppression Validation

Mailpit was queried before and after the failure interval.

| Measurement | Value |
|---|:---:|
| Messages before interruption | `0` |
| Messages after problem generation | `0` |
| New messages during maintenance | `0` |
| Expected new messages | `0` |

No maintenance-related problem notification was delivered.

This confirmed that the trigger action respected the suppressed-incident configuration.

## Service Restoration

The `monitored-web` service was started after the controlled failure interval.

The restoration validation confirmed:

- the container returned to the `healthy` state;
- monitored-web TCP availability returned to `1`;
- the HTTP scenario failed-step value returned to `0`;
- the HTTP response code returned to `200`;
- PostgreSQL TCP availability remained at `1`;
- the HTTP problem recovered automatically;
- Mailpit still contained zero messages.

The HTTP incident recovered at `19:53:15`, after a duration of `5m 56s`.

![Suppressed HTTP recovery](../../docs/screenshots/stage-07-suppressed-http-recovery.png)

## Maintenance Closure

After the monitored service returned to its normal state, the maintenance period was formally closed.

The active-until value was adjusted to `20:04`, and the maintenance status changed to `Expired`.

This confirmed that:

- the approved maintenance window had ended;
- the host was no longer under maintenance;
- the maintenance indicator was removed;
- future incidents would be processed outside the completed maintenance context.

![Expired maintenance period](../../docs/screenshots/stage-07-expired-maintenance-period.png)

## Post-Maintenance Validation

The final platform validation confirmed:

| Validation | Expected | Observed | Result |
|---|:---:|:---:|:---:|
| PostgreSQL container | Healthy | Healthy | Passed |
| Zabbix Server container | Running | Running | Passed |
| Zabbix Web container | Healthy | Healthy | Passed |
| `monitored-web` container | Healthy | Healthy | Passed |
| Mailpit container | Healthy | Healthy | Passed |
| Zabbix frontend | HTTP `200` | HTTP `200` | Passed |
| Mailpit frontend | HTTP `200` | HTTP `200` | Passed |
| Monitored-web TCP availability | `1` | `1` | Passed |
| HTTP scenario failed step | `0` | `0` | Passed |
| HTTP response code | `200` | `200` | Passed |
| Mailpit messages | `0` | `0` | Passed |
| Maintenance status | Expired | Expired | Passed |

The host maintenance indicator was no longer displayed, and no active HTTP availability incident remained.

![Post-maintenance platform validation](../../docs/screenshots/stage-07-post-maintenance-platform-validation.png)

## Operational Documentation

The maintenance activity produced two dedicated operational records.

### Planned Maintenance Record

The maintenance record documents:

- the change scope;
- objectives and risks;
- preconditions;
- maintenance configuration;
- execution timeline;
- monitoring results;
- notification behavior;
- service restoration;
- maintenance closure;
- final outcome.

[View the planned maintenance record](maintenance-record.md)

### Shift Handover Report

The shift-handover report documents:

- work completed during the shift;
- current platform state;
- current monitoring values;
- incident and notification summaries;
- outstanding unrelated alerts;
- incoming-shift actions;
- escalation criteria;
- rollback status;
- evidence index.

[View the shift handover report](shift-handover-report.md)

## Evidence Index

| Evidence | Repository file |
|---|---|
| Active maintenance period | `docs/screenshots/stage-07-active-maintenance-period.png` |
| Controlled HTTP unavailability | `docs/screenshots/stage-07-controlled-http-unavailability.png` |
| Suppressed HTTP problem | `docs/screenshots/stage-07-suppressed-http-problem.png` |
| Suppressed HTTP recovery | `docs/screenshots/stage-07-suppressed-http-recovery.png` |
| Expired maintenance period | `docs/screenshots/stage-07-expired-maintenance-period.png` |
| Post-maintenance validation | `docs/screenshots/stage-07-post-maintenance-platform-validation.png` |

## Safety and Scope

The workflow was limited to the controlled laboratory environment.

The PostgreSQL database, Zabbix Server, Zabbix Web, Mailpit, Windows Agent 2, and unrelated monitored hosts were not intentionally interrupted.

The `monitored-web` service was the only controlled maintenance target.

No production system, external SMTP service, personal email account, credential, token, or public infrastructure was used.

## Troubleshooting Notes

### Maintenance initially extended beyond the test

The maintenance period was initially configured with an active-until value later than the operational test required.

After service recovery, the end time was adjusted to formally close the maintenance and confirm its `Expired` state.

### Suppressed incident hidden by the default filter

The HTTP problem did not appear in the default incident view because suppressed incidents were not displayed.

Enabling `Show suppressed incidents` exposed the expected maintenance-related problem event.

### Monitoring failure versus notification failure

The absence of a Mailpit message did not indicate a monitoring failure.

Zabbix successfully detected the service interruption and generated the expected problem event. Only the notification operation was paused because the event was suppressed during maintenance.

### Historical web-scenario error after recovery

The last HTTP error message remained temporarily visible in recent data after the web scenario recovered.

The current TCP value, failed-step value, response code, incident state, and container health were used to confirm the real operational status.

## Key Learnings

This stage demonstrated that:

- maintenance does not necessarily stop monitoring-data collection;
- planned work can generate problem events while suppressing operational actions;
- suppressed incidents remain available for audit and investigation;
- incident filters must include suppressed events when validating maintenance behavior;
- notification suppression must be verified independently from problem detection;
- service recovery should be confirmed through multiple monitoring signals;
- maintenance periods must be formally closed after planned work;
- shift handover should distinguish maintenance-related events from unrelated alerts;
- operational evidence should preserve the complete change lifecycle;
- documentation is part of the technical maintenance process.

## Final Result

Stage 07 successfully demonstrated the complete planned-maintenance lifecycle:

1. baseline validation;
2. maintenance activation;
3. continued data collection;
4. controlled service interruption;
5. problem detection;
6. incident suppression;
7. notification suppression;
8. service restoration;
9. automatic recovery;
10. maintenance closure;
11. post-maintenance validation;
12. operational reporting.

The laboratory returned to its normal state, the maintenance period expired, the HTTP incident was resolved, and no unintended notification was delivered.

**Stage 07 completed successfully.**

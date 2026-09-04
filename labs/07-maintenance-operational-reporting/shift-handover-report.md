# NOC Shift Handover Report — Stage 07

[Back to Stage 07](README.md)

## Handover Summary

| Field | Value |
|---|---|
| Environment | Zabbix NOC Operations Lab |
| Handover date | September 4, 2026 |
| Related change | `CHG-LAB-007` |
| Activity | Monitored-web planned maintenance |
| Zabbix host | `Zabbix Lab Internal Services` |
| Affected service | `monitored-web` |
| Maintenance status | Expired |
| Service status | Restored and healthy |
| Notification status | No maintenance-related messages delivered |
| Overall result | Successful |
| Follow-up required | No corrective action required |

## Executive Summary

The planned maintenance activity identified as `CHG-LAB-007` was completed successfully.

The `monitored-web` service was intentionally interrupted while its Zabbix host was under an active maintenance period configured with data collection.

Zabbix continued collecting monitoring data, detected the service interruption, created the expected HTTP availability problem, marked the incident as suppressed, and prevented the associated Mailpit notification operation.

The service was restored successfully, the problem recovered automatically, the maintenance period was closed, and the platform returned to its normal operational state.

## Work Completed During the Shift

The following activities were completed:

- validated the Docker platform baseline;
- confirmed access to the Zabbix and Mailpit frontends;
- created the planned maintenance period;
- associated the maintenance with `Zabbix Lab Internal Services`;
- retained monitoring-data collection during maintenance;
- verified the trigger-action suppression setting;
- recorded the initial Mailpit message count;
- stopped only the `monitored-web` service;
- confirmed TCP and HTTP monitoring failures;
- confirmed creation of the expected problem event;
- confirmed that the incident was suppressed;
- confirmed that no unintended notification reached Mailpit;
- restored the `monitored-web` service;
- confirmed TCP and HTTP recovery;
- confirmed automatic incident resolution;
- closed the maintenance period;
- completed the post-maintenance validation;
- preserved the operational evidence in the repository.

## Change Timeline

| Time | Event | Operational result |
|:---:|---|---|
| 19:25 | Maintenance became active | Host entered planned maintenance |
| 19:46:05 | Controlled test started | Initial Mailpit count recorded as zero |
| 19:46 | `monitored-web` was stopped | Controlled service interruption began |
| 19:47:19 | HTTP problem was created | High-severity incident detected and suppressed |
| 19:49:08 | Notification check completed | Mailpit remained at zero messages |
| 19:52:36 | Service restoration started | `monitored-web` container was started |
| 19:53:15 | HTTP problem recovered | Incident changed to `RESOLVED` |
| 19:58:58 | Recovery checks completed | Service healthy and monitoring values normal |
| 20:04 | Maintenance ended | Maintenance changed to `Expired` |
| 20:05:30 | Final validation completed | Platform confirmed in normal operation |

## Current Platform State

| Component | Current state | Operational note |
|---|:---:|---|
| PostgreSQL | Healthy | Database service remained available |
| Zabbix Server | Running | Event processing remained operational |
| Zabbix Web | Healthy | Frontend returned HTTP status `200` |
| Monitored web service | Healthy | Service restored successfully |
| Mailpit | Healthy | Frontend returned HTTP status `200` |
| Zabbix maintenance | Expired | Host is no longer under maintenance |

## Current Monitoring State

| Monitoring signal | Current value | Expected value | Status |
|---|:---:|:---:|:---:|
| Monitored-web TCP availability | `1` | `1` | Normal |
| HTTP scenario failed step | `0` | `0` | Normal |
| HTTP response code | `200` | `200` | Normal |
| PostgreSQL TCP availability | `1` | `1` | Normal |
| HTTP availability incident | Resolved | Resolved | Normal |
| Maintenance indicator | Not displayed | Not displayed | Normal |

The `Zabbix Lab Internal Services` host is no longer displaying the maintenance indicator.

![Post-maintenance platform state](../../docs/screenshots/stage-07-post-maintenance-platform-validation.png)

## Incident Summary

The controlled interruption generated the expected incident:

| Field | Value |
|---|---|
| Incident | `HTTP service unavailable on monitored-web` |
| Severity | High |
| Problem time | 19:47:19 |
| Recovery time | 19:53:15 |
| Duration | 5 minutes and 56 seconds |
| Suppression state | Suppressed during maintenance |
| Notification delivery | Not executed |
| Final state | Resolved |

The incident lifecycle remains available in Zabbix history for operational review.

![Suppressed HTTP recovery](../../docs/screenshots/stage-07-suppressed-http-recovery.png)

## Notification Summary

| Mailpit measurement | Value |
|---|:---:|
| Messages before the interruption | `0` |
| Messages during the failure | `0` |
| Messages after service restoration | `0` |
| Messages after maintenance closure | `0` |
| Unexpected notifications | `0` |

The absence of a maintenance-related message was the expected result.

The configured trigger action paused notification operations because the incident was suppressed by the active maintenance period.

## Maintenance Closure

The maintenance period named `NOC Lab - Monitored Web Planned Maintenance` was formally closed after service recovery.

Its final status is `Expired`.

No active maintenance window remains associated with the test, and future events for the host will be processed outside the completed maintenance context.

![Expired maintenance period](../../docs/screenshots/stage-07-expired-maintenance-period.png)

## Outstanding Alerts

The Stage 07 HTTP incident is resolved and requires no further corrective action.

Other alerts displayed in the Zabbix incident view belong to separately monitored Windows and Linux hosts. They existed outside the scope of `CHG-LAB-007` and were not caused by the planned maintenance activity.

These unrelated alerts should continue to be handled according to their own operational priority and troubleshooting procedures.

## Actions for the Incoming Shift

No immediate action is required for `CHG-LAB-007`.

The incoming operator should:

- keep the Docker laboratory services running while additional validation is required;
- confirm that `monitored-web` remains healthy;
- confirm that TCP availability remains at `1`;
- confirm that the HTTP response code remains `200`;
- verify that no maintenance indicator returns unexpectedly;
- treat any new HTTP availability problem as a normal unsuppressed incident;
- investigate unrelated Windows or Linux alerts separately;
- preserve the Stage 07 evidence and operational records.

## Escalation Criteria

Escalation is required if any of the following conditions occurs:

- the `monitored-web` container leaves the healthy state;
- monitored-web TCP availability changes from `1` to `0`;
- the HTTP web scenario reports a failed step;
- the HTTP response code differs from `200`;
- the completed maintenance period becomes active again;
- an HTTP problem remains suppressed outside an approved maintenance window;
- Mailpit receives an unexpected maintenance-related notification;
- the HTTP availability problem returns after service restoration.

## Rollback Status

No rollback was required.

The controlled interruption was reversed by starting the existing `monitored-web` container. No image, network, volume, database, trigger, item, action, or media-type configuration required restoration.

## Evidence Index

| Evidence | Repository file |
|---|---|
| Active maintenance period | `docs/screenshots/stage-07-active-maintenance-period.png` |
| Controlled HTTP unavailability | `docs/screenshots/stage-07-controlled-http-unavailability.png` |
| Suppressed HTTP problem | `docs/screenshots/stage-07-suppressed-http-problem.png` |
| Suppressed HTTP recovery | `docs/screenshots/stage-07-suppressed-http-recovery.png` |
| Expired maintenance period | `docs/screenshots/stage-07-expired-maintenance-period.png` |
| Post-maintenance validation | `docs/screenshots/stage-07-post-maintenance-platform-validation.png` |

## Related Documentation

- [Stage 07 documentation](README.md)
- [Planned maintenance record](maintenance-record.md)
- [Main repository documentation](../../README.md)

## Handover Status

**SHIFT HANDOVER COMPLETE — PLATFORM OPERATIONAL**

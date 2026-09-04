# Stage 07 - Maintenance Windows and Operational Reporting

[Back to the main README](../../README.md)

## Objective

This stage introduces planned-maintenance handling and operational reporting practices commonly performed by Network Operations Center teams.

The implementation will validate how Zabbix behaves when a monitored service is intentionally interrupted during an approved maintenance window.

The stage will cover:

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
- incident-record preparation;
- shift-handover reporting;
- troubleshooting notes and selected evidence.

## Current Status

**In progress**

The laboratory platform and the monitoring baseline were validated before the maintenance workflow began.

## Pre-Maintenance Baseline

The initial validation confirmed:

- PostgreSQL was healthy;
- Zabbix Server was running;
- Zabbix Web was healthy and returned HTTP status `200`;
- Mailpit was healthy and returned HTTP status `200`;
- the monitored HTTP container was healthy;
- monitored web TCP availability was `1`;
- the HTTP scenario returned status code `200`;
- the HTTP scenario had no failed step;
- no active HTTP incident existed for `Zabbix Lab Internal Services`.

Unrelated Windows service and Ubuntu WSL agent incidents were present in the environment, but they did not affect the selected maintenance target.

## Planned Maintenance Workflow

The maintenance validation will follow this sequence:

1. register the planned activity;
2. configure a maintenance period in Zabbix;
3. associate `Zabbix Lab Internal Services` with the maintenance;
4. keep monitoring-data collection enabled;
5. confirm that the maintenance period is active;
6. stop the `monitored-web` service intentionally;
7. validate the suppressed problem behavior;
8. confirm that no unnecessary notification reaches Mailpit;
9. restore the monitored service;
10. validate service recovery;
11. end or remove the maintenance period;
12. confirm the normal post-maintenance state;
13. complete the operational records and shift report.

## Maintenance Target

| Field | Value |
|---|:---:|
| Zabbix host | `Zabbix Lab Internal Services` |
| Service | `monitored-web` |
| Monitoring signal | HTTP service availability |
| Expected normal value | `1` |
| Controlled action | Temporary container stop |
| Maintenance type | With data collection |
| Notification expectation | No unnecessary problem notification |
| Recovery expectation | Service returns to the normal state |

## Evidence Plan

The final evidence set will include:

- pre-maintenance platform baseline;
- active maintenance-period configuration;
- suppressed HTTP problem during maintenance;
- Mailpit notification-suppression validation;
- service restoration;
- post-maintenance normal state;
- completed maintenance record;
- operational shift-handover report.

## Safety and Scope

This workflow is limited to the controlled laboratory environment.

The PostgreSQL database, Zabbix Server, Zabbix Web, Mailpit, Windows Agent 2, and unrelated monitored hosts will not be intentionally interrupted.

The `monitored-web` service will be the only controlled maintenance target.

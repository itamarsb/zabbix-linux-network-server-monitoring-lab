# Zabbix NOC Operations Lab

[![Zabbix](https://img.shields.io/badge/Zabbix-7.0%20LTS-D40000?logo=zabbix&logoColor=white)](https://www.zabbix.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Linux](https://img.shields.io/badge/Linux-Monitoring-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![Windows](https://img.shields.io/badge/Windows-Monitoring-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows/)
[![Status](https://img.shields.io/badge/Status-Stage%2007%20Completed-brightgreen)](#implementation-roadmap)

A practical Network Operations Center lab focused on infrastructure monitoring, alert delivery, triage, troubleshooting, incident response, service recovery, maintenance coordination, and operational documentation.

Zabbix is the central monitoring platform. The project reproduces common NOC workflows across Linux, Windows, network connectivity, HTTP services, incident handling, operator notifications, and planned maintenance.

## Project Purpose

This repository demonstrates a complete monitoring and incident-handling cycle:

**Monitor → Detect → Notify → Validate → Acknowledge → Investigate → Escalate or Restore → Confirm Recovery → Document**

The objective is not limited to installing Zabbix. Each stage includes implementation, validation, controlled failure simulation, troubleshooting, recovery, and selected technical evidence.

## Core Objectives

- Deploy a reproducible Zabbix 7.0 LTS environment.
- Monitor Linux and Windows hosts with Zabbix Agent 2.
- Monitor host availability, system resources, processes, and services.
- Validate ICMP, DNS, TCP port, and HTTP availability.
- Configure items, triggers, events, problems, severities, and actions.
- Deliver automated problem and recovery notifications.
- Practice alert acknowledgment, investigation, escalation, and recovery.
- Simulate infrastructure, network, and application incidents.
- Create reusable troubleshooting runbooks.
- Document incidents, maintenance windows, and shift activities.
- Introduce SNMP monitoring for network-oriented scenarios.
- Add Grafana only as an optional visualization layer after the core Zabbix workflows are complete.

## Architecture Overview

| Layer | Component | Relationship |
|:---:|:---:|---|
| Operations | NOC operator | Uses the Zabbix frontend and reviews captured notifications |
| Presentation | Zabbix Web | Provides configuration, monitoring, incident, and maintenance views |
| Processing | Zabbix Server | Collects data, evaluates triggers, processes events, and executes actions |
| Persistence | PostgreSQL | Stores Zabbix configuration, history, trends, and events |
| Monitoring targets | Linux, Windows, and internal services | Provide host, resource, network, TCP, DNS, and HTTP signals |
| Notification | Mailpit | Captures local SMTP problem and recovery notifications |

The platform runs locally through Docker Desktop and WSL 2.

PostgreSQL remains inside the Docker network. Mailpit provides isolated SMTP capture for notification validation. Only the interfaces required for administration, monitoring, and local message inspection are exposed to the workstation.

## Monitoring Scope

| Area | Coverage |
|:---:|---|
| Host availability | Agent availability, ICMP reachability, and response time |
| Linux | CPU, memory, disk, processes, services, logs, and network interfaces |
| Windows | CPU, memory, disk, services, event information, and Agent 2 |
| Network | ICMP, packet loss, latency, DNS resolution, and TCP connectivity |
| HTTP services | Availability, status code, response time, and controlled service failure |
| Zabbix operations | Hosts, templates, items, triggers, events, problems, actions, and media types |
| Alert delivery | SMTP capture, problem notifications, recovery notifications, and delivery history |
| Incident handling | Triage, acknowledgment, notes, severity, escalation, and recovery |
| Maintenance | Planned downtime, event suppression, notification suppression, and recovery validation |
| Reporting | Maintenance records, operational checklists, and shift-handover reports |
| Network devices | Introductory SNMP monitoring |
| Visualization | Native Zabbix dashboards and optional Grafana integration |

## Incident Scenarios

The laboratory reproduces scenarios commonly handled by NOC and infrastructure teams:

- monitored host unavailable;
- Zabbix Agent 2 unavailable;
- HTTP service stopped;
- TCP port inaccessible;
- DNS resolution failure;
- high CPU utilization;
- low available disk space;
- abnormal memory utilization;
- network latency or packet loss;
- service blocked by a local firewall;
- planned maintenance generating unnecessary alerts;
- poorly tuned trigger producing a false positive.

Each completed scenario must contain detection evidence, diagnostic steps, corrective action, recovery validation, and an operational record.

## Troubleshooting Method

1. Identify the alert source and affected asset.
2. Validate whether the problem is current and reproducible.
3. Determine the impact, scope, and severity.
4. Check connectivity, resources, services, ports, and logs.
5. Compare recent changes and related events.
6. Verify action execution and notification delivery when applicable.
7. Apply the documented recovery procedure when authorized.
8. Escalate when the issue exceeds the operator's access or responsibility.
9. Confirm recovery from both the system and monitoring perspectives.
10. Record actions, timestamps, findings, and follow-up recommendations.

## Current Repository Contents

- [`labs/00-workstation-validation/`](labs/00-workstation-validation/) - workstation baseline, acceptance criteria, findings, and results;
- [`labs/01-zabbix-platform/`](labs/01-zabbix-platform/) - reproducible Zabbix platform deployment, validation, troubleshooting, and evidence;
- [`labs/02-linux-host-monitoring/`](labs/02-linux-host-monitoring/) - Linux host monitoring with Zabbix Agent 2, controlled resource validation, lifecycle testing, and evidence;
- [`labs/03-windows-host-monitoring/`](labs/03-windows-host-monitoring/) - Windows host monitoring with Zabbix Agent 2, DNS-based Docker connectivity, metric discovery, controlled CPU validation, and evidence;
- [`labs/04-network-service-monitoring/`](labs/04-network-service-monitoring/) - ICMP, DNS, TCP, and HTTP service monitoring, controlled failure, recovery validation, troubleshooting, and evidence;
- [`labs/05-triggers-alert-handling/`](labs/05-triggers-alert-handling/) - sustained trigger conditions, severity classification, HTTP and DNS incidents, acknowledgment, recovery, historical validation, and evidence;
- [`labs/06-alert-delivery-notifications/`](labs/06-alert-delivery-notifications/) - Mailpit SMTP capture, Zabbix media type, severity-aware action, problem and recovery notifications, delivery troubleshooting, and evidence;
- [`labs/07-maintenance-operational-reporting/`](labs/07-maintenance-operational-reporting/) - planned maintenance, continued data collection, problem and notification suppression, controlled recovery, maintenance closure, operational reporting, and evidence;
- [`scripts/powershell/validate-workstation.ps1`](scripts/powershell/validate-workstation.ps1) - reusable read-only workstation validation;
- [`compose.yaml`](compose.yaml) - PostgreSQL, Zabbix Server, Zabbix Web, dedicated monitored HTTP service, Mailpit, persistent storage, and isolated networks;
- [`.env.example`](.env.example) - versioned environment-variable template without operational credentials;
- [`docs/screenshots/`](docs/screenshots/) - selected technical evidence from completed stages;
- [`.gitignore`](.gitignore) - protection for secrets, runtime data, logs, local overrides, and temporary files.

Additional directories will be introduced only when they contain implemented and validated material.

## Implementation Roadmap

| Stage | Scope | Status |
|:---:|---|:---:|
| 00 | Workstation validation and repository baseline | Completed |
| 01 | Zabbix platform deployment and health validation | Completed |
| 02 | Linux host monitoring with Zabbix Agent 2 | Completed |
| 03 | Windows host monitoring with Zabbix Agent 2 | Completed |
| 04 | Network, DNS, TCP, and HTTP service monitoring | Completed |
| 05 | Triggers, severities, events, and alert handling | Completed |
| 06 | Alert delivery, actions, and notifications | Completed |
| 07 | Maintenance windows and operational reporting | Completed |
| 08 | Introductory SNMP and optional Grafana integration | Planned |

A stage is marked as completed only after its implementation, validation, troubleshooting notes, and relevant evidence are committed.

## Completed Stages

### Stage 00 - Workstation Validation

Stage 00 established and validated the local workstation baseline before any Zabbix service deployment.

The validation covered:

- Windows, PowerShell, and system architecture;
- processor, memory, and available disk capacity;
- WSL 2 and its active kernel;
- Docker Engine and Docker Compose;
- resources available to Docker;
- required TCP ports;
- DNS resolution and outbound HTTPS connectivity;
- existing containers, networks, and volumes;
- Git repository state.

Final validation result:

| Result | Count |
|---|:---:|
| Passed | `20` |
| Warnings | `0` |
| Failed | `0` |
| Final decision | Workstation approved |

See the complete documentation in [`labs/00-workstation-validation/README.md`](labs/00-workstation-validation/README.md).

### Stage 01 - Zabbix Platform Deployment

Stage 01 delivered a reproducible Zabbix 7.0 LTS platform composed of PostgreSQL, Zabbix Server, and Zabbix Web.

The implementation included:

- pinned container image versions;
- an internal database network;
- persistent PostgreSQL storage;
- loopback-only published ports;
- database health validation;
- controlled environment variables;
- local HTTP availability validation;
- replacement of default administrative credentials;
- investigation and correction of an inappropriate template relationship;
- confirmation of platform recovery with no current problems.

See the complete documentation in [`labs/01-zabbix-platform/README.md`](labs/01-zabbix-platform/README.md).

### Stage 02 - Linux Host Monitoring

Stage 02 introduced the first monitored Linux host: Ubuntu 24.04 LTS running under WSL 2 with Zabbix Agent 2.

The implementation included:

- installation from the official Zabbix 7.0 repository;
- passive Agent 2 checks on TCP port `10050`;
- Docker-to-WSL connectivity and authorization validation;
- direct `zabbix_get` checks for availability, host identity, and agent version;
- host registration with the `Linux by Zabbix agent` template;
- collection of CPU, memory, swap, filesystem, storage, process, operating-system, and network data;
- investigation of transient unsupported items during template initialization;
- controlled CPU, memory, filesystem, and network activity;
- WSL termination and automatic Agent 2 recovery validation;
- selected initial, final, dashboard, and memory-test evidence.

All acceptance criteria passed, and the monitored Linux host remained operational after the lifecycle and resource tests.

See the complete documentation in [`labs/02-linux-host-monitoring/README.md`](labs/02-linux-host-monitoring/README.md).

### Stage 03 - Windows Host Monitoring

Stage 03 introduced the first monitored Windows host: a native Windows 11 Pro workstation running Zabbix Agent 2 as a Windows service.

The implementation included:

- Windows host, network-interface, service, firewall, and TCP-port baseline validation;
- Docker-to-Windows connectivity through `host.docker.internal`;
- discovery and restriction of the required Docker network authorization scope;
- download and verification of the official Zabbix Agent 2 `7.0.30` MSI;
- SHA-256 and Authenticode validation before installation;
- preservation of the original Agent configuration;
- passive Agent checks through TCP port `10050`;
- a restricted inbound Windows Firewall rule;
- direct `zabbix_get` validation from the Zabbix Server container;
- creation of the `Windows servers` host group;
- host registration with a DNS-based Agent interface;
- assignment of the `Windows by Zabbix agent` template;
- validation of Agent availability and `146` monitored values after initial discovery;
- collection of CPU, memory, swap, uptime, process, thread, disk, filesystem, network-interface, and service data;
- a controlled two-minute CPU workload using six of eight logical processors;
- observation of CPU utilization increasing to `89.5912%` and recovering to `36.6596%`;
- selected host-availability, latest-data, workload, and recovery evidence.

All acceptance criteria passed, and the Windows monitoring path remained available throughout the controlled activity and recovery validation.

See the complete documentation in [`labs/03-windows-host-monitoring/README.md`](labs/03-windows-host-monitoring/README.md).

### Stage 04 - Network, DNS, TCP, and HTTP Service Monitoring

Stage 04 extended host-level monitoring with native network and service availability checks.

The implementation included:

- ICMP availability, packet-loss, and response-time monitoring for `1.1.1.1`;
- external DNS resolution monitoring through Zabbix Agent 2 and Cloudflare DNS;
- internal TCP availability checks for PostgreSQL and a dedicated HTTP target;
- a dedicated Nginx service isolated from the Zabbix platform and database;
- an HTTP web scenario validating content, response code, response time, and download speed;
- Docker DNS and cross-network connectivity validation;
- a controlled interruption of only the monitored HTTP service;
- observation of TCP availability changing from `1` to `0` and returning to `1`;
- observation of the web-scenario failed step changing from `0` to `1` and returning to `0`;
- preservation of PostgreSQL and the Zabbix platform throughout the failure;
- error-history review and complete service-recovery validation;
- selected normal-state, failure-state, error, and recovery evidence.

All acceptance criteria passed. The stage confirmed that the monitoring platform could detect an isolated service outage, preserve diagnostic information, and verify recovery without affecting essential laboratory services.

See the complete documentation in [`labs/04-network-service-monitoring/README.md`](labs/04-network-service-monitoring/README.md).

### Stage 05 - Triggers, Severities, Events, and Alert Handling

Stage 05 converted the monitoring signals established in the previous stages into actionable incidents and complete operational lifecycles.

The implementation included:

- a sustained HTTP service-availability trigger with High severity;
- controlled interruption and restoration of the dedicated `monitored-web` service;
- HTTP problem generation, acknowledgment, investigation notes, and escalation decisions;
- automatic HTTP event resolution and preservation of the complete event history;
- an additional external DNS resolution trigger with Average severity;
- validation and rejection of an ineffective initial fault-injection attempt;
- deterministic DNS failure through a controlled temporary target change;
- observation of the monitored DNS value changing from `1` to `0` and returning to `1`;
- automatic DNS incident recovery and historical validation;
- removal of temporary Windows Firewall rules used during troubleshooting;
- selected HTTP and DNS detection, acknowledgment, failure, recovery, and history evidence.

All acceptance criteria passed. The stage demonstrated severity-based incident classification, operator accountability, controlled troubleshooting, automatic recovery, and complete historical preservation for two distinct monitoring signals.

See the complete documentation in [`labs/05-triggers-alert-handling/README.md`](labs/05-triggers-alert-handling/README.md).

### Stage 06 - Alert Delivery, Actions, and Notifications

Stage 06 converted the Stage 05 monitoring events into complete operator-notification workflows.

The implementation included:

- deployment of Mailpit as a local SMTP capture service;
- a loopback-only Mailpit web interface;
- creation of the `Mailpit Local SMTP` Zabbix media type;
- assignment of the laboratory recipient `noc-operator@zabbix-lab.local`;
- activation of notification delivery for Average, High, and Disaster severities;
- creation of the `NOC Lab - Mailpit problem notifications` trigger action;
- action conditions restricted to the selected HTTP and DNS triggers;
- a minimum action severity of Average;
- custom problem and recovery message templates;
- direct media-type delivery validation;
- a controlled High-severity HTTP failure and recovery lifecycle;
- successful HTTP problem and recovery email delivery;
- an Average-severity DNS failure generated through a deterministic temporary target change;
- successful DNS problem and recovery email delivery;
- validation of action execution and delivery status through the Zabbix action log;
- diagnosis and correction of missing media-type message templates;
- restoration of the HTTP service and original DNS item key;
- selected platform, message, action, problem, and recovery evidence.

All acceptance criteria passed. The stage demonstrated severity-aware notification processing, automated problem and recovery delivery, local SMTP validation, delivery-history analysis, and systematic troubleshooting of a failed notification path.

See the complete documentation in [`labs/06-alert-delivery-notifications/README.md`](labs/06-alert-delivery-notifications/README.md).

### Stage 07 - Maintenance Windows and Operational Reporting

Stage 07 extended the alert-delivery workflow with planned-maintenance coordination and formal operational reporting.

The implementation included:

- creation of the `NOC Lab - Monitored Web Planned Maintenance` maintenance period;
- association of `Zabbix Lab Internal Services` with the active maintenance;
- configuration of maintenance with continued data collection;
- validation of the trigger action option to pause operations for suppressed incidents;
- recording of the initial Mailpit message count;
- controlled interruption of only the `monitored-web` service;
- observation of TCP availability changing from `1` to `0`;
- observation of the HTTP web-scenario failed step changing from `0` to `1`;
- generation of the High-severity `HTTP service unavailable on monitored-web` incident;
- confirmation that the maintenance-related incident was suppressed;
- confirmation that Mailpit received zero new messages during the failure;
- restoration of the `monitored-web` container;
- observation of TCP availability returning to `1`;
- observation of the HTTP response code returning to `200`;
- automatic incident recovery after `5m 56s`;
- formal maintenance closure and confirmation of its `Expired` status;
- removal of the host maintenance indicator;
- successful post-maintenance validation of all Docker services;
- creation of a planned-maintenance record;
- creation of a shift-handover report;
- selected maintenance, suppression, failure, recovery, and final-state evidence.

All acceptance criteria passed. The stage demonstrated that Zabbix can continue collecting monitoring data during planned work, retain suppressed problem events for audit purposes, prevent unnecessary notification operations, confirm service recovery, and support formal NOC change and handover documentation.

Stage 07 documentation:

- [Stage 07 overview](labs/07-maintenance-operational-reporting/README.md)
- [Planned maintenance record](labs/07-maintenance-operational-reporting/maintenance-record.md)
- [Shift handover report](labs/07-maintenance-operational-reporting/shift-handover-report.md)

## Current Stage

### Stage 08 - Introductory SNMP and Optional Grafana Integration

The next stage will introduce and validate:

- basic SNMP concepts used in network monitoring;
- SNMP polling from the Zabbix platform;
- a controlled SNMP-enabled laboratory target;
- host registration through an SNMP interface;
- standard system and interface OIDs;
- SNMP items and value interpretation;
- interface availability and traffic monitoring;
- trigger behavior for an SNMP-monitored condition;
- native Zabbix visualization for SNMP data;
- optional Grafana integration after the native Zabbix workflow is complete;
- troubleshooting of SNMP connectivity and community configuration;
- selected SNMP and visualization evidence.

Implementation files will be committed only after configuration and validation succeed.

## Evidence Policy

Evidence is selected to demonstrate meaningful technical results rather than every mouse click.

Relevant evidence may include:

- platform and host availability;
- recognizable Zabbix host, status, and monitoring views;
- item data collection;
- metric graphs showing controlled change and recovery;
- trigger transition from `OK` to `PROBLEM`;
- acknowledged incident with an operational note;
- notification received by the configured operator;
- successful problem and recovery action history;
- diagnostic command output;
- confirmed service recovery;
- trigger transition back to `OK`;
- maintenance period configuration;
- completed maintenance or shift report;
- SNMP item collection;
- interface traffic visualization.

Screenshots containing credentials, tokens, personal information, or unrelated desktop content must not be committed.

## Security Practices

- Secrets and credentials are excluded from version control.
- PostgreSQL is not published directly to the Windows host.
- Mailpit is used only as a controlled local SMTP capture service.
- Administrative and notification interfaces are bound to loopback where applicable.
- Environment-specific values remain outside tracked configuration.
- Example files use placeholders instead of real passwords.
- Private keys and certificates are ignored by Git.
- Diagnostic evidence is reviewed before publication.
- Existing resources from unrelated projects are preserved.
- Temporary test changes are removed after validation.
- Maintenance periods are closed after controlled operational work.

## Technology Stack

- Zabbix 7.0 LTS
- Zabbix Agent 2
- PostgreSQL
- Docker Desktop
- Docker Compose
- WSL 2
- Linux
- Windows PowerShell
- Nginx
- Mailpit
- SMTP
- SNMP
- Grafana as an optional final-stage visualization layer

## Skills Demonstrated

- infrastructure and service monitoring;
- NOC alert triage;
- Linux and Windows administration;
- network connectivity validation;
- Zabbix media-type and action configuration;
- severity-aware alert delivery;
- SMTP notification validation;
- problem and recovery message design;
- notification troubleshooting;
- incident response;
- troubleshooting methodology;
- service restoration;
- operational escalation;
- planned-maintenance coordination;
- event and notification suppression;
- change validation and closure;
- shift-handover preparation;
- technical documentation;
- monitoring-as-code fundamentals;
- Docker-based environment management.

## Project Status

Stages 00, 01, 02, 03, 04, 05, 06, and 07 are complete, validated, and documented.

Stage 08 is the next planned implementation and will introduce SNMP monitoring for a controlled network-oriented target. Native Zabbix monitoring and visualization will be completed before any optional Grafana integration is considered.

---

This repository is a controlled laboratory environment intended for technical practice and portfolio demonstration. It is not a production deployment guide.

---

## 📈 Repository Metrics

<p align="center">
  <a href="https://info.flagcounter.com/iBrN">
    <img
      src="https://s01.flagcounter.com/count/iBrN/bg_FFFFFF/txt_000000/border_CCCCCC/columns_8/maxflags_100/viewers_0/labels_1/pageviews_1/flags_0/percent_0/"
      alt="Flag Counter"
      width="900"
    />
  </a>
</p>

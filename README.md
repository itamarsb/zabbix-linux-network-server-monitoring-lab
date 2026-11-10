# Zabbix NOC Operations Lab

**English** | [Português (Brasil)](README.pt-BR.md)

[![Zabbix](https://img.shields.io/badge/Zabbix-7.0%20LTS-D40000?logo=zabbix&logoColor=white)](https://www.zabbix.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Linux](https://img.shields.io/badge/Linux-Monitoring-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![Windows](https://img.shields.io/badge/Windows-Monitoring-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows/)
[![Status](https://img.shields.io/badge/Status-Stage%2008%20Completed-brightgreen)](#implementation-roadmap)

This repository documents a hands-on monitoring laboratory built with Zabbix 7.0 LTS, Docker, Linux, and Windows.

The project follows the evolution of a small monitoring environment, from platform deployment to host and network monitoring, incident detection, alert delivery, service recovery, planned maintenance, and SNMP.

Each laboratory explains the configuration, tests performed, observed results, and operational findings. Selected screenshots and command outputs accompany the procedures where they help clarify the outcome.

The environment is intended for learning and experimentation, not as a production deployment template.

## How to Use This Repository

Start with [Stage 00](labs/00-workstation-validation/README.md) to review workstation prerequisites and [Stage 01](labs/01-zabbix-platform/README.md) to understand the Zabbix platform. Stages 02–04 cover Linux and Windows hosts, connectivity, and service monitoring; Stages 05–08 extend the environment with incidents, notifications, maintenance, and SNMP.

The [Implementation Roadmap](#implementation-roadmap) links directly to each stage. For day-to-day alert handling, see the [NOC alert triage checklist](docs/noc-alert-triage-checklist.md).

The stage documents distinguish results observed during the original exercises from reference commands intended for future runs. Individual experiments may have limitations or incomplete validations; these are noted alongside their results.

## Architecture Overview

| Layer | Component | Relationship |
|:---:|:---:|:---:|
| Operations | NOC operator | Uses the Zabbix frontend and reviews captured notifications |
| Presentation | Zabbix Web | Provides configuration, monitoring, incident, and maintenance views |
| Processing | Zabbix Server | Collects data, evaluates triggers, processes events, and executes actions |
| Persistence | PostgreSQL | Stores Zabbix configuration, history, trends, and events |
| Monitoring targets | Linux, Windows, internal services, and a controlled SNMP target | Provide host, resource, network, TCP, DNS, HTTP, SNMP system, interface, and traffic signals |
| Notification | Mailpit | Captures local SMTP problem and recovery notifications |

The laboratory runs locally using Docker Desktop and WSL 2. Docker Compose separates backend and monitoring traffic: the `backend` network is marked `internal: true`, while `monitoring` is a regular Docker bridge. Host-published laboratory endpoints are bound to loopback where specified; this does not, by itself, restrict traffic between containers on the same network. PostgreSQL has no host-published port, and Mailpit captures test SMTP messages locally.

## Monitoring Scope

| Area | Coverage |
|:---:|:---:|
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
| Network devices | SNMPv2c system polling, interface discovery, operational status, and traffic monitoring |
| Visualization | Native Zabbix dashboards and graphs; Grafana evaluated and intentionally deferred |

## Implementation Roadmap

Stages 00–08 are documented as completed laboratory milestones. The table highlights representative outcomes; the linked stage documents contain implementation details, commands, original measurements, and supporting evidence.

| Stage | Focus | Documented outcome |
|:---:|---|---|
| [00 — Workstation](labs/00-workstation-validation/README.md) | Windows, WSL 2, Docker, ports, and prerequisites | 20 validation checks passed; no warnings or failures |
| [01 — Zabbix Platform](labs/01-zabbix-platform/README.md) | PostgreSQL, Zabbix Server, and Zabbix Web | Local monitoring platform deployed and validated |
| [02 — Linux](labs/02-linux-host-monitoring/README.md) | Zabbix Agent 2, resource metrics, and WSL lifecycle | Agent collection, controlled resource activity, and recovery verified |
| [03 — Windows](labs/03-windows-host-monitoring/README.md) | Agent 2, network permissions, Windows services, and CPU | 146 monitored values after initial discovery; controlled CPU response observed |
| [04 — Network and Services](labs/04-network-service-monitoring/README.md) | ICMP, DNS, TCP, and HTTP checks | Isolated HTTP-service interruption and recovery observed |
| [05 — Incidents](labs/05-triggers-alert-handling/README.md) | Triggers, severity, acknowledgment, and investigation | HTTP and DNS problem-and-recovery events recorded |
| [06 — Notifications](labs/06-alert-delivery-notifications/README.md) | Zabbix actions, SMTP, and Mailpit | HTTP and DNS problem/recovery notifications delivered in the lab |
| [07 — Maintenance](labs/07-maintenance-operational-reporting/README.md) | Planned maintenance, suppression, and handover | Maintenance-related incident suppressed and service recovered |
| [08 — SNMP](labs/08-snmp-grafana-integration/README.md) | Net-SNMP, OIDs, interface traffic, and authentication | SNMP collection and authentication recovery verified; optional notification path not validated |

**Important limitations:** The Stage 05 initial DNS firewall-blocking attempt did not produce the intended monitoring failure; removal of its earlier UDP-specific test rule is not verified by the preserved record. In Stage 08, no SNMP notification delivery was observed in Mailpit and the dedicated notification action remained disabled. These findings are documented in their respective stages, not treated as successful experiments.

Grafana was evaluated in Stage 08 but not added: the existing Zabbix dashboards and graphs met the visualization needs of that laboratory.

## Incident Scenarios

The laboratory distinguishes validated fault-injection exercises, monitored resource variations, and scenarios proposed for future validation.

### Validated controlled scenarios

- HTTP service interruption, TCP/HTTP unavailability, problem detection, and recovery (Stages 04–07).
- Controlled DNS resolution failure, problem detection, and recovery (Stages 05–06).
- Planned maintenance with continued data collection and suppression of incident notifications (Stage 07).
- Controlled SNMP authentication failure, problem detection, and recovery (Stage 08).

### Validated resource and network monitoring

- Controlled CPU workload and monitoring response (Stages 02–03).
- Memory allocation, temporary filesystem usage, and network traffic variations (Stage 02).
- ICMP availability, response-time, and packet-loss monitoring under observed conditions (Stage 04).

These activities validate monitoring behavior but do not necessarily demonstrate incident generation.

### Candidate scenarios for future validation

- Monitored host or Zabbix Agent 2 unavailability.
- Critically low available disk space or memory-related threshold violations.
- Induced network latency or packet loss.
- Effective service blocking through a local firewall.
- A false-positive incident caused by an incorrectly tuned trigger.

These scenarios must not be presented as experimentally validated until corresponding tests and evidence are documented.

Each completed incident scenario should include detection evidence, diagnostic steps, corrective actions where applicable, recovery validation, and an operational record.

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

## Repository Reference Files

The stage READMEs above provide the full laboratory procedures. Additional project files are available for setup, operations, and evidence:

- [`compose.yaml`](compose.yaml) — service definitions, storage, published endpoints, and Docker networks
- [`.env.example`](.env.example) — sample environment variables without operational secrets
- [`scripts/powershell/validate-workstation.ps1`](scripts/powershell/validate-workstation.ps1) — read-only workstation validation script
- [`snmp/`](snmp/) — Net-SNMP target image, startup script, and agent configuration
- [NOC alert triage checklist](docs/noc-alert-triage-checklist.md) — a reusable diagnostic and handover reference
- [Planned maintenance record](labs/07-maintenance-operational-reporting/maintenance-record.md) and [shift handover report](labs/07-maintenance-operational-reporting/shift-handover-report.md) — operational records from Stage 07
- [`docs/screenshots/`](docs/screenshots/) — selected screenshots from the exercises
- [`.gitignore`](.gitignore) — exclusions for local secrets, runtime data, logs, and temporary files

## Evidence and Reproduction

The stage documents retain the measurements, commands, incident timelines, and selected screenshots used to explain each test. Examples include Zabbix item values and graphs, `OK`/`PROBLEM` transitions, action history, Mailpit messages, service recovery, maintenance records, and SNMP interface traffic.

Reference commands added for future reproductions are identified separately from original execution evidence. The historical results do not automatically describe the state of a newly deployed environment. Screenshots and logs should exclude credentials, secrets, personal information, and unrelated desktop content.

## Security Practices

- Operational credentials, SNMP communities, tokens, private keys, and environment-specific values remain outside version control. Example configuration uses placeholders.
- PostgreSQL is not exposed through a host-published port. Administration and test-service endpoints are bound to loopback where defined by the Compose file; this must not be confused with isolation between Docker containers.
- Mailpit is used only for local SMTP testing, not as a production mail service. SNMPv2c community strings are not encrypted in transit.
- Sensitive Zabbix macros use secret-text configuration, and an exposed laboratory community was rotated during Stage 08.
- Temporary test changes require explicit cleanup and verification. Where the preserved evidence does not confirm a final state, the relevant stage records that limitation.
- Existing resources from unrelated projects are not intentionally modified; evidence is checked for sensitive information before publication.

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
- SNMPv2c
- Net-SNMP
- Alpine Linux

## Operational Topics

The exercises cover Linux and Windows administration, container operations, agent and network connectivity, Zabbix items and triggers, NOC incident triage, severity classification, notification delivery, troubleshooting, service recovery, planned maintenance, shift handover, SNMP polling, interface discovery, and technical documentation.

The emphasis is on understanding the monitoring signals, choosing appropriate checks, and interpreting what each test actually demonstrates.

## Project Status

Stages 00–08 have been implemented and documented, with the individual results and limitations available in their linked READMEs. This does not mean that every optional scenario or reference procedure has been executed.

The Stage 08 SNMP notification action remains unvalidated and disabled; the HTTP and DNS notification workflows were validated separately in Stage 06. Grafana was deferred because native Zabbix visualization met the needs of the Stage 08 tests.

This is an educational laboratory, not a production installation or a guarantee that the recorded environment remains running in its historical state.

## Repository Metrics

<p align="center">
  <a href="https://info.flagcounter.com/iBrN">
    <img
      src="https://s01.flagcounter.com/count/iBrN/bg_FFFFFF/txt_000000/border_CCCCCC/columns_8/maxflags_100/viewers_0/labels_1/pageviews_1/flags_0/percent_0/"
      alt="Flag Counter"
      width="900"
    />
  </a>
</p>
